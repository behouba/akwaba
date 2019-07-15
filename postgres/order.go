package postgres

import (
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

func (o *OrderStore) CustomerOrders(customerID uint) (orders []akwaba.Order, err error) {
	rows, err := o.db.Query(
		`SELECT
		o.order_id, o.time_created, o.sender_name, o.sender_phone, 
		o.sender_area_id, a1.name, o.sender_address, o.recipient_name, 
		o.recipient_phone, o.recipient_area_id, a2.name, o.recipient_address,
		o.shipment_category_id, sc.name, o.nature, o.payment_option_id, po.name,
		ost.order_state_id, ost.name
		FROM orders AS o
		LEFT JOIN order_states AS ost
		ON o.order_state_id = ost.order_state_id
		LEFT JOIN shipment_categories AS sc
		ON sc.shipment_category_id = o.shipment_category_id
		LEFT JOIN payment_options AS po
		ON po.payment_option_id = o.payment_option_id
		LEFT JOIN areas as a1
		ON a1.area_id = o.sender_area_id
		LEFT JOIN areas as a2
		ON a2.area_id = o.recipient_area_id
		WHERE customer_id=$1 ORDER BY o.time_created DESC`,
		customerID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order
		err = rows.Scan(
			&o.OrderID, &o.TimeCreated, &o.Sender.Name, &o.Sender.Phone,
			&o.Sender.Area.ID, &o.Sender.Area.Name,
			&o.Sender.Address, &o.Recipient.Name,
			&o.Recipient.Phone, &o.Recipient.Area.ID, &o.Recipient.Area.Name,
			&o.Recipient.Address, &o.Category.ID, &o.Category.Name,
			&o.Nature, &o.PaymentOption.ID, &o.PaymentOption.Name,
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

// Save order
func (s *OrderStore) Save(o *akwaba.Order) (err error) {
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
		shipment_category_id, nature, payment_option_id, cost, distance)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) RETURNING order_id`,
		o.CustomerID, o.Sender.Name, o.Sender.Phone, o.Sender.Area.ID, o.Sender.Address,
		o.Recipient.Name, o.Recipient.Phone, o.Recipient.Area.ID, o.Recipient.Address,
		o.Category.ID, o.Nature, o.PaymentOption.ID, o.Cost, o.Distance,
	).Scan(&o.OrderID)
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

func (o *OrderStore) OrderByID(orderID uint64) (order akwaba.Order, err error) {
	// var shipments json.RawMessage
	// o.db.QueryRow(
	// 	`SELECT
	// 	o.order_id, o.customer_id, o.time_created, o.order_state_id, ost.name, shipments
	// 	FROM orders AS o
	// 	INNER JOIN order_states AS ost
	// 	ON o.order_state_id = ost.order_state_id
	// 	WHERE o.order_id=$1`,
	// 	orderID,
	// ).Scan(
	// 	&order.OrderID, &order.CustomerID, &order.TimeCreated,
	// 	&order.State.ID, &order.State.Name, &shipments,
	// )
	// // log.Println(string(shipments))
	// err = json.Unmarshal(shipments, &order.Shipments)
	// if err != nil {
	// 	return
	// }
	return
}

func (o *OrderStore) Confirm(orderID uint64) (err error) {
	return
}

func (o *OrderStore) Cancel(orderID uint64) (err error) {
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

// Track method take an order id and return current trace data of order with error
func (d *OrderStore) Track(userID, orderID int) (oTrace akwaba.Order, err error) {
	// if userID != 0 {
	// 	log.Printf("Retriving order tracking by user %d for order %d info from database...\n", userID, orderID)
	// 	return
	// }
	// log.Printf("Retriving order tracking by unknow user for order %d info from database...\n", orderID)
	return
}
