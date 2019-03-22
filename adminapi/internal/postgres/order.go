package postgres

import (
	"database/sql"
	"errors"
	"log"

	"github.com/behouba/dsapi"
)

const (
	oStateWaitingConfirmation = 1
	oStateWaitingPickUp       = 2
	oStateInProcessing        = 3
	oStateCanceled            = 4
	oStateFrozen              = 5
	oStateTerminated          = 6
)

// OrderStore implement the AdminOrderer interface
type OrderStore struct {
	DB *sql.DB
}

// Pending retreive all pending order related to the employee office id
func (o *OrderStore) Pending(areaID int) (orders []dsapi.Order, err error) {
	rows, err := o.DB.Query(
		`SELECT 
		orders.id, pickup_address.id as pickup_address_id
		FROM orders
		INNER JOIN pickup_address ON orders.address_id = pickup_address.id 
		WHERE pickup_address.area_id=$1 AND orders.state_id =$2;`,
		areaID, oStateWaitingPickUp,
	)

	for rows.Next() {
		var order dsapi.Order
		err = rows.Scan(
			&order.ID, &order.PickUpAddressID,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		orders = append(orders, order)
	}
	return
}

// Get method retreive order by id from database
func (o *OrderStore) Get(id int) (order dsapi.Order, err error) {
	err = o.DB.QueryRow(
		`SELECT id, customer_id, payment_type_id, cost, created_at, address_id, state_id 
		FROM orders WHERE id=$1`,
		id,
	).Scan(
		&order.ID, &order.CustomerID, &order.PaymentTypeID,
		&order.TotalCost, &order.CreatedAt, &order.PickUpAddressID, &order.State,
	)
	return
}

// Confirm update order in database and mark it as confirmed
func (o *OrderStore) Confirm(id int) (err error) {
	var stateID int
	err = o.DB.QueryRow(
		`SELECT state_id FROM orders WHERE id=$1`,
		id,
	).Scan(&stateID)
	if err != nil {
		return
	}
	if stateID != oStateWaitingConfirmation {
		return errors.New("Cette commande est déja confirmée")
	}
	_, err = o.DB.Exec(
		`UPDATE orders SET state_id=$1 WHERE id=$2`,
		oStateWaitingPickUp, id,
	)
	return
}

// Cancel update order in database and mark it as cancel
func (o *OrderStore) Cancel(id int) (err error) {
	var stateID int
	err = o.DB.QueryRow(
		`SELECT state_id FROM orders WHERE id=$1`,
		id,
	).Scan(&stateID)
	if err != nil {
		return
	}
	if stateID != oStateWaitingConfirmation && stateID != oStateWaitingPickUp {
		return errors.New("Desolé cette commande ne peut etre annulée")
	}
	_, err = o.DB.Exec(
		`UPDATE orders SET state_id=$1 WHERE id=$2`,
		oStateCanceled, id,
	)
	return
}

// Save save order created by admin agent into database
func (o *OrderStore) Save(order *dsapi.Order) (id int, err error) {
	order.State = oStateWaitingPickUp
	err = o.DB.QueryRow(
		`INSERT
		INTO orders (customer_id, payment_type_id, address_id, state_id)
		VALUES ($1, $2, $3, $4)
		RETURNING id`,
		order.CustomerID, order.PaymentTypeID,
		order.PickUpAddressID, order.State,
	).Scan(&id)
	if err != nil {
		return
	}

	for i, p := range order.Parcels {
		p.Cost = p.ComputeCost(id)
		p.StateID = pStateWaitingPickUp
		err = o.DB.QueryRow(
			`INSERT
			INTO parcel (order_id, weight, description, address_id, state_id, cost)
			VALUES ($1, $2, $3, $4, $5, $6)
			RETURNING id`,
			id, p.Weight, p.Description,
			p.DeliveryAddressID, p.StateID,
			p.Cost,
		).Scan(&order.Parcels[i].ID)
		if err != nil {
			log.Println(err)
			return
		}
		order.Parcels[i].Cost = p.Cost
		order.Parcels[i].StateID = p.StateID
	}

	_, err = o.DB.Exec(
		`UPDATE orders SET cost=$1 WHERE id=$2`,
		order.ComputeCost(), id,
	)
	return
}
