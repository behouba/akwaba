package postgres

import (
	"encoding/json"
	"log"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

type OrderStore struct {
	db *sqlx.DB
	Calculator
}

func NewOrderStore(db *sqlx.DB) *OrderStore {
	return &OrderStore{db: db}
}

func (o *OrderStore) CustomerOrders(customerID uint) (orders []akwaba.Order, err error) {
	rows, err := o.db.Query(
		`SELECT 
		o.order_id, o.time_created, o.order_state_id, ost.name, o.shipments 
		FROM orders AS o
		INNER JOIN order_states AS ost
		ON o.order_state_id = ost.order_state_id
		WHERE customer_id=$1 ORDER BY o.time_created DESC`,
		customerID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order
		var r json.RawMessage
		err = rows.Scan(&o.OrderID, &o.TimeCreated, &o.State.ID, &o.State.Name, &r)
		if err != nil {
			log.Println(err)
			continue
		}
		err = json.Unmarshal(r, &o.Shipments)
		if err != nil {
			log.Println(err)
			continue
		}
		orders = append(orders, o)
	}
	return
}

// SaveOrder save order
func (o *OrderStore) Save(shipments []akwaba.Shipment, customerID uint) (orderID uint64, err error) {

	shipmentsBytes, err := json.Marshal(shipments)
	if err != nil {
		return
	}

	err = o.db.QueryRow(
		"INSERT INTO orders (customer_id, order_state_id, shipments) VALUES ($1, $2, $3) RETURNING order_id",
		customerID, akwaba.OrderStatePendingID, json.RawMessage(shipmentsBytes),
	).Scan(&orderID)
	return
}

func (o *OrderStore) Cancel(orderID uint64) (err error) {
	return
}

func (o *OrderStore) OrderByID(orderID uint64) (order akwaba.Order, err error) {
	var shipments json.RawMessage
	o.db.QueryRow(
		`SELECT 
		o.order_id, o.customer_id, o.time_created, o.order_state_id, ost.name, shipments
		FROM orders AS o
		INNER JOIN order_states AS ost
		ON o.order_state_id = ost.order_state_id
		WHERE o.order_id=$1`,
		orderID,
	).Scan(
		&order.OrderID, &order.CustomerID, &order.TimeCreated,
		&order.State.ID, &order.State.Name, &shipments,
	)
	// log.Println(string(shipments))
	err = json.Unmarshal(shipments, &order.Shipments)
	if err != nil {
		return
	}
	return
}

// CompleteOrder function complete order information
// func (d *OrderStore) CompleteOrder(order *akwaba.Order) (err error) {
// 	order.Sender.City.Name, err = d.cityNameByID(order.Sender.City.ID)
// 	if err != nil {
// 		return
// 	}
// 	order.Receiver.City.Name, err = d.cityNameByID(order.Receiver.City.ID)
// 	if err != nil {
// 		return
// 	}
// 	order.ComputeCost()
// 	order.ShipmentCategory.Name, err = d.intervalNameByID(order.ShipmentCategory.ID)
// 	if err != nil {
// 		return
// 	}
// 	order.PaymentType.Name, err = d.paymentTypeNameByID(order.PaymentType.ID)
// 	if err != nil {
// 		return
// 	}
// 	return
// }

// CancelOrder update order state to "canceled"
func (d *OrderStore) CancelOrder(orderID uint64, userID uint) (id int, err error) {
	// Will check ownership of user before performing modification
	// on order state in database
	// err = d.db.QueryRow(
	// 	`UPDATE delivery_order SET state_id=$1 WHERE id=$2 AND customer_id=$3 RETURNING id`,
	// 	akwaba.OrderCanceled.ID, orderID, userID,
	// ).Scan(&id)
	// if err == nil {
	// 	log.Printf("User %d just canceled order %d...", userID, orderID)
	// }
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

func (d *OrderStore) ActiveOrders(userID uint) (orders []akwaba.Order, err error) {
	// rows, err := d.db.Query(
	// 	`SELECT d.id, d.sender_data, d.receiver_data, w.name, d.nature, p.name, d.cost,
	// 	d.created_at, st.name, st.id
	// 	FROM delivery_order AS d
	// 	LEFT JOIN weight_interval AS w
	// 	ON w.id = d.weight_interval_id
	// 	LEFT JOIN payment_type AS p
	// 	ON p.id = d.payment_type_id
	// 	LEFT JOIN order_state AS st
	// 	ON st.id = d.state_id
	// 	WHERE d.customer_id=$1 ORDER BY d.state_id ASC`,
	// 	userID,
	// )

	// if err != nil {
	// 	return
	// }

	// for rows.Next() {
	// 	var o akwaba.Order

	// 	err = rows.Scan(
	// 		&o.OrderID, &o.Sender, &o.Receiver, &o.ShipmentCategory.Name,
	// 		&o.Nature, &o.PaymentType.Name, &o.Cost, &o.CreatedAt.RealTime, &o.State.Name, &o.State.ID,
	// 	)

	// 	if err != nil {
	// 		log.Println(err)
	// 		continue
	// 	}

	// 	o.CreatedAt.FormatTimeFR()
	// 	orders = append(orders, o)
	// }
	return
}

func (d *OrderStore) ArchivedOrders(userID uint) (orders []akwaba.Order, err error) {
	// rows, err := d.db.Query(
	// 	`SELECT
	// 		delivery_order.id, payment_type.name as payment_type, cost,
	// 		sender_full_name, sender_phone, sender_city.name as sender_city,
	// 		sender_address, receiver_full_name, receiver_phone,
	// 		receiver_city.name  as receiver_city, receiver_address,
	// 		nature,weight_interval.name as weight_interval, created_at,
	// 		state_id, order_state.name as order_state
	// 	FROM delivery_order
	// 	LEFT JOIN order_state ON
	// 		delivery_order.state_id = order_state.id
	// 	LEFT JOIN city as sender_city ON
	// 		delivery_order.sender_city_id = sender_city.id
	// 	LEFT JOIN city as receiver_city ON
	// 		delivery_order.receiver_city_id = receiver_city.id
	// 	LEFT JOIN payment_type ON
	// 		delivery_order.payment_type_id = payment_type.id
	// 	LEFT JOIN weight_interval ON
	// 		delivery_order.weight_interval_id = weight_interval.id
	// 	WHERE customer_id=$1 AND (state_id=$2 OR state_id=$3)
	// 	ORDER BY created_at DESC;`,
	// 	userID, akwaba.OrderCanceled, akwaba.OrderClosed,
	// )
	// if err != nil {
	// 	return
	// }
	// for rows.Next() {
	// 	var o akwaba.Order

	// 	err = rows.Scan(
	// 		&o.OrderID, &o.PaymentType.Name, &o.Cost, &o.Sender.Name,
	// 		&o.Sender.Phone, &o.Sender.City.Name, &o.Sender.Address,
	// 		&o.Receiver.Name, &o.Receiver.Phone, &o.Receiver.City.Name,
	// 		&o.Receiver.Address, &o.Nature, &o.ShipmentCategory.Name, &o.CreatedAt.RealTime,
	// 		&o.State.ID, &o.State.Name,
	// 	)
	// 	if err != nil {
	// 		log.Println(err)
	// 		continue
	// 	}
	// 	o.CreatedAt.FormatTimeFR()
	// 	orders = append(orders, o)
	// }
	return
}
