package postgres

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"

	"github.com/behouba/akwaba"
)

// AdminDB hold database connection for admin users
type AdminDB struct {
	db *sql.DB
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
	fmt.Println("Successfully connected to database")
	a.db = db
	return
}

// ToConfirm retreive all ToConfirm order related to the employee office id
func (a *AdminDB) ToConfirm(officeID int) (orders []akwaba.Order, err error) {
	rows, err := a.db.Query(
		`SELECT
			delivery_order.id, payment_type.name as payment_type, cost, 
			sender_full_name, sender_phone, sender_city.name as sender_city, 
			sender_address, receiver_full_name, receiver_phone, 
			receiver_city.name  as receiver_city, receiver_address, note, 
			nature,weight_interval.name as weight_interval, created_at,
			state_id, order_state.name as order_state
		FROM delivery_order
		INNER JOIN order_state ON
			delivery_order.state_id = order_state.id
		INNER JOIN city as sender_city ON
			delivery_order.sender_city_id = sender_city.id
		INNER JOIN city as receiver_city ON
			delivery_order.receiver_city_id = receiver_city.id
		INNER JOIN payment_type ON
			delivery_order.payment_type_id = payment_type.id
		INNER JOIN weight_interval ON
			delivery_order.weight_interval_id = weight_interval.id
		WHERE state_id=$1
		ORDER BY created_at DESC;`,
		akwaba.OrderStateWaitingConfirmation,
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

// ToPickUp retreive all ToPickUp order related to the employee office id
func (a *AdminDB) ToPickUp(officeID int) (orders []akwaba.Order, err error) {
	rows, err := a.db.Query(
		`SELECT
			delivery_order.id, payment_type.name as payment_type, cost, 
			sender_full_name, sender_phone, sender_city.name as sender_city, 
			sender_address, receiver_full_name, receiver_phone, 
			receiver_city.name  as receiver_city, receiver_address, note, 
			nature,weight_interval.name as weight_interval, created_at,
			state_id, order_state.name as order_state
		FROM delivery_order
		INNER JOIN order_state ON
			delivery_order.state_id = order_state.id
		INNER JOIN city as sender_city ON
			delivery_order.sender_city_id = sender_city.id
		INNER JOIN city as receiver_city ON
			delivery_order.receiver_city_id = receiver_city.id
		INNER JOIN payment_type ON
			delivery_order.payment_type_id = payment_type.id
		INNER JOIN weight_interval ON
			delivery_order.weight_interval_id = weight_interval.id
		WHERE state_id=$1
		ORDER BY created_at DESC;`,
		akwaba.OrderStateWaitingPickUp,
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

func (a *AdminDB) CancelOrder(id int) (err error) {
	_, err = a.db.Exec(
		`UPDATE delivery_order SET state_id=$1 WHERE id=$2;`,
		akwaba.OrderStateCanceled, id,
	)
	if err != nil {
		return
	}
	return
}

func (a *AdminDB) ConfirmOrder(id int) (err error) {
	_, err = a.db.Exec(
		`UPDATE delivery_order SET state_id=$1 WHERE id=$2;`,
		akwaba.OrderStateWaitingPickUp, id,
	)
	if err != nil {
		return
	}
	return
}
