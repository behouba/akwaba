package postgres

import (
	"errors"
	"fmt"
	"log"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

type OrderStore struct {
	db *sqlx.DB
	PricingStorage
}

func NewOrderStore(db *sqlx.DB, mapApiKey string) *OrderStore {
	o := OrderStore{db: db}
	o.PricingStorage.db, o.PricingStorage.apiKey = db, mapApiKey
	return &o
}

// o.order_id, s.shipment_id,o.customer_id, o.time_created,o.time_closed,o.sender_name,
// o.sender_phone,o.sender_area_id,sender_area,o.sender_address,o.recipient_name,
// o.recipient_phone,o.recipient_area_id,recipient_area,o.recipient_address,
// o.shipment_category_id, shipment_category, o.nature, o.payment_option_id,
// payment_option, o.cost,o.distance,ost.order_state_id,order_state

func (o *OrderStore) Orders(customerID uint, offset uint64) (orders []akwaba.Order, err error) {
	rows, err := o.db.Query(
		`select * from full_orders
		WHERE customer_id=$1 ORDER BY time_created DESC LIMIT 50 OFFSET $2`,
		customerID, offset,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var o akwaba.Order
		err = rows.Scan(
			&o.OrderID, &o.ShipmentID, &o.CustomerID, &o.TimeCreated, &o.TimeClosed,
			&o.Sender.Name, &o.Sender.Phone, &o.Sender.Area.ID, &o.Sender.Area.Name,
			&o.Sender.Address, &o.Recipient.Name, &o.Recipient.Phone, &o.Recipient.Area.ID,
			&o.Recipient.Area.Name, &o.Recipient.Address, &o.Category.ID, &o.Category.Name,
			&o.Nature, &o.PaymentOption.ID, &o.PaymentOption.Name, &o.Cost, &o.Distance,
			&o.State.ID, &o.State.Name,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		orders = append(orders, o)
	}
	return
}

func (s *OrderStore) isAllowed(customerID uint) (err error) {
	var n uint8
	s.db.QueryRow(
		`SELECT COUNT(*) FROM orders WHERE customer_id=$1 AND order_state_id=$2`,
		customerID, akwaba.OrderStatePendingID,
	).Scan(&n)
	if n > 4 {
		return errors.New(
			fmt.Sprintf(
				"Vous avez %d commades en attente de confirmation",
				n,
			),
		)
	}
	return
}

// Save order
func (s *OrderStore) Save(o *akwaba.Order) (err error) {
	err = s.isAllowed(o.CustomerID)
	if err != nil {
		return
	}
	const orderState = akwaba.OrderStatePendingID
	err = s.setAreaID(o.Sender.Area.Name, &o.Sender.Area.ID)
	if err != nil {
		return
	}
	err = s.setAreaID(o.Recipient.Area.Name, &o.Recipient.Area.ID)
	if err != nil {
		return
	}
	o.Cost, o.Distance, err = s.Cost(o.Sender.Area.Name, o.Recipient.Area.Name, o.Category.ID)
	if err != nil {
		return
	}

	err = s.db.QueryRow(
		`INSERT
		INTO orders 
		(customer_id, sender_name, sender_phone, 
		sender_area_id, sender_address, recipient_name, 
		recipient_phone, recipient_area_id, recipient_address, 
		shipment_category_id, nature, payment_option_id, cost, distance, order_state_id)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15) RETURNING order_id`,
		o.CustomerID, o.Sender.Name, o.Sender.Phone, o.Sender.Area.ID, o.Sender.Address,
		o.Recipient.Name, o.Recipient.Phone, o.Recipient.Area.ID, o.Recipient.Address,
		o.Category.ID, o.Nature, o.PaymentOption.ID, o.Cost, o.Distance, orderState,
	).Scan(&o.OrderID)
	if err != nil {
		return
	}

	_, err = s.db.Exec(
		`INSERT INTO orders_history 
		(order_id, order_state_id)
		VALUES ($1, $2)`,
		o.OrderID,
		orderState,
	)
	if err != nil {
		return
	}
	return
}

func (s *OrderStore) setAreaID(name string, id *uint) (err error) {
	return s.db.QueryRow(
		`SELECT area_id FROM areas WHERE name LIKE '%' || $1 || '%'`,
		name,
	).Scan(id)
}

func (s *OrderStore) Order(orderID uint64, customerID uint) (o akwaba.Order, err error) {
	err = s.db.QueryRow(
		`select * from full_orders
		WHERE order_id=$1 AND customer_id=$2 ORDER BY time_created DESC`,
		orderID, customerID,
	).Scan(
		&o.OrderID, &o.ShipmentID, &o.CustomerID, &o.TimeCreated, &o.TimeClosed,
		&o.Sender.Name, &o.Sender.Phone, &o.Sender.Area.ID, &o.Sender.Area.Name,
		&o.Sender.Address, &o.Recipient.Name, &o.Recipient.Phone, &o.Recipient.Area.ID,
		&o.Recipient.Area.Name, &o.Recipient.Address, &o.Category.ID, &o.Category.Name,
		&o.Nature, &o.PaymentOption.ID, &o.PaymentOption.Name, &o.Cost, &o.Distance,
		&o.State.ID, &o.State.Name,
	)
	if err != nil {
		return
	}
	return
}

func (o *OrderStore) Cancel(orderID uint64) (err error) {
	_, err = o.db.Exec(
		`UPDATE orders 
		SET order_state_id=$1 
		WHERE order_id=$2 AND order_state_id=$3`,
		akwaba.OrderStateCanceledID, orderID, akwaba.OrderStatePendingID,
	)
	if err != nil {
		return
	}
	return
}

// Track method take an order id and return current trace data of order with error
func (d *OrderStore) Track(userID, orderID int) (oTrace akwaba.Order, err error) {
	// if userID != 0 {
	// 	log.Printf("Retriving order tracking by user %d for order %d info from database...\n", userID, orderID)
	// 	return
	// }
	// log.Printf("Retriving order tracking by unknow user for order %d info from database...\n", orderID)
	return
}
