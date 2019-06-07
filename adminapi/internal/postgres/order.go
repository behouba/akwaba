package postgres

import (
	"database/sql"
	"errors"
	"fmt"
	"log"

	_ "github.com/lib/pq"

	"github.com/behouba/akwaba"
)

// AdminDB hold database connection for admin users
type AdminDB struct {
	db              *sql.DB
	Cities          []akwaba.City
	WeightIntervals []akwaba.WeightInterval
	PaymentTypes    []akwaba.PaymentType
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func (a *AdminDB) Open(uri string) (err error) {

	db, err := sql.Open("postgres", uri)
	if err != nil {
		return err
	}

	err = db.Ping()
	if err != nil {
		return err
	}
	a.Cities, err = akwaba.GetAllCities(db)
	if err != nil {
		return
	}
	a.WeightIntervals, err = akwaba.GetWeightIntervals(db)
	if err != nil {
		return
	}
	a.PaymentTypes, err = akwaba.GetPaymentType(db)
	if err != nil {
		return
	}
	fmt.Println("Successfully connected to database")
	a.db = db
	return
}

// ToConfirm retreive all pending orders that belong to the office id
func (a *AdminDB) ToConfirm(emp *akwaba.Employee) (orders []akwaba.Order, err error) {
	rows, err := a.db.Query(
		`SELECT
			d.id, pt.name as payment_type, cost, 
			sender_full_name, sender_phone, sc.name as sender_city, 
			sender_address, receiver_full_name, receiver_phone, 
			rc.name  as receiver_city, receiver_address, note, 
			nature,w.name as weight_interval, created_at,
			state_id, ost.name as order_state
		FROM delivery_order as d
		LEFT JOIN order_state as ost ON
			d.state_id = ost.id
		LEFT JOIN city as sc ON
			d.sender_city_id = sc.id
		LEFT JOIN city as rc ON
			d.receiver_city_id = rc.id
		LEFT JOIN payment_type as pt ON
			d.payment_type_id = pt.id
		LEFT JOIN weight_interval as w ON
			d.weight_interval_id = w.id
		WHERE state_id=$1 AND  sc.office_id=$2
		ORDER BY created_at DESC;`,
		akwaba.OrderStateWaitingConfirmation, emp.Office.ID,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var o akwaba.Order

		err = rows.Scan(&o.ID, &o.PaymentType.Name, &o.Cost, &o.Sender.FullName,
			&o.Sender.Phone, &o.Sender.City.Name, &o.Sender.Address,
			&o.Receiver.FullName, &o.Receiver.Phone, &o.Receiver.City.Name,
			&o.Receiver.Address, &o.Note, &o.Nature, &o.WeightInterval.Name, &o.CreatedAt.RealTime,
			&o.State.ID, &o.State.Name,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		o.CreatedAt.FormatTimeFR()
		orders = append(orders, o)
	}
	return
}

// ToPickUp retreive all orders waiting to be picked up by provided office id
func (a *AdminDB) ToPickUp(emp *akwaba.Employee) (orders []akwaba.Order, err error) {
	rows, err := a.db.Query(
		`SELECT
			d.id, pt.name as payment_type, cost, 
			sender_full_name, sender_phone, sc.name as sender_city, 
			sender_address, receiver_full_name, receiver_phone, 
			rc.name  as receiver_city, receiver_address, note, 
			nature,w.name as weight_interval, created_at,
			state_id, ost.name as order_state
		FROM delivery_order as d
		LEFT JOIN order_state as ost ON
			d.state_id = ost.id
		LEFT JOIN city as sc ON
			d.sender_city_id = sc.id
		LEFT JOIN city as rc ON
			d.receiver_city_id = rc.id
		LEFT JOIN payment_type as pt ON
			d.payment_type_id = pt.id
		LEFT JOIN weight_interval as w ON
			d.weight_interval_id = w.id
		WHERE state_id=$1 AND  sc.office_id=$2
		ORDER BY created_at DESC;`,
		akwaba.OrderStateWaitingPickUp, emp.Office.ID,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var o akwaba.Order

		err = rows.Scan(&o.ID, &o.PaymentType.Name, &o.Cost, &o.Sender.FullName,
			&o.Sender.Phone, &o.Sender.City.Name, &o.Sender.Address,
			&o.Receiver.FullName, &o.Receiver.Phone, &o.Receiver.City.Name,
			&o.Receiver.Address, &o.Note, &o.Nature, &o.WeightInterval.Name, &o.CreatedAt.RealTime,
			&o.State.ID, &o.State.Name,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		o.CreatedAt.FormatTimeFR()
		orders = append(orders, o)
	}
	return
}

// CreateOrder take a pointer to an order, save it to database return and err
func (a *AdminDB) CreateOrder(order *akwaba.Order) (err error) {
	err = a.db.QueryRow(
		`INSERT INTO delivery_order 
		(payment_type_id, cost, sender_full_name, sender_phone, 
			sender_city_id, sender_address, receiver_full_name, receiver_phone, 
			receiver_city_id, receiver_address, note, nature, weight_interval_id, state_id)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) RETURNING id;`,
		order.PaymentType.ID, order.ComputeCost(), order.Sender.FullName,
		order.Sender.Phone, order.Sender.City.ID, order.Sender.Address,
		order.Receiver.FullName, order.Receiver.Phone, order.Receiver.City.ID,
		order.Receiver.Address, order.Note, order.Nature, order.WeightInterval.ID,
		akwaba.OrderStateWaitingPickUp,
	).Scan(&order.ID)
	return
}

func (a *AdminDB) CancelOrder(id int, emp *akwaba.Employee) (err error) {
	err = a.changeOrderState(id, akwaba.OrderStateCanceled)
	if err != nil {
		return
	}
	go a.recordActivity(
		fmt.Sprintf(
			"Commande %d annulée par l'administrateur %s",
			id, emp.FullName,
		),
	)
	return
}

func (a *AdminDB) ConfirmOrder(id int, emp *akwaba.Employee) (err error) {
	err = a.changeOrderState(id, akwaba.OrderStateWaitingPickUp)
	if err != nil {
		return
	}
	go a.recordActivity(fmt.Sprintf("Commande %d confirmée par l'administrateur %s", id, emp.FullName))
	return
}

func (a *AdminDB) SetCollectedOrders(orderIDs []int, emp *akwaba.Employee) (err error) {
	for _, id := range orderIDs {
		err = a.changeOrderState(id, akwaba.OrderStateInProcessing)
		if err != nil {
			log.Println(err)
			continue
		}
		_, err = a.addNewParcel(id, emp.Office.ID)
		if err != nil {
			log.Println(err)
			continue
		}
		go a.recordActivity(fmt.Sprintf(
			"Ramassage de la commande %d confirmée par l'administrateur %s",
			id, emp.FullName,
		))
	}
	return
}

func (a *AdminDB) changeOrderState(id, stateID int) (err error) {
	var currentStateID int
	err = a.db.QueryRow(
		`SELECT state_id from delivery_order WHERE id=$1`,
		id,
	).Scan(&currentStateID)
	if err != nil {
		return
	}
	log.Printf("current state %d, new state %d", currentStateID, stateID)
	err = checkStateChangeValidity(currentStateID, stateID)
	if err != nil {
		return
	}
	_, err = a.db.Exec(
		`UPDATE delivery_order SET state_id=$1 WHERE id=$2;`,
		stateID, id,
	)
	if err != nil {
		return
	}
	return
}

func checkStateChangeValidity(currentStateID, stateID int) (err error) {
	switch currentStateID {
	case stateID:
		return errors.New("La commande à deja le status souhaitée")
	case akwaba.OrderStateWaitingConfirmation:
		if stateID != akwaba.OrderStateWaitingPickUp && stateID != akwaba.OrderStateCanceled {
			return errors.New("Ce changement de status de commande n'est pas authorisé")
		}
	case akwaba.OrderStateWaitingPickUp:
		if stateID != akwaba.OrderStateInProcessing && stateID != akwaba.OrderStateCanceled {
			return errors.New("Ce changement de status de commande n'est pas authorisé")
		}
	case akwaba.OrderStateInProcessing:
		if stateID != akwaba.OrderStateClosed {
			return errors.New("Ce changement de status de commande n'est pas authorisé")
		}
	case akwaba.OrderStateClosed:
		return errors.New("Cette commande est déja terminée, impossible de changer son status")
	case akwaba.OrderStateCanceled:
		return errors.New("Cette commande est déja annulée, impossible de changer son status")
	}
	return
}
