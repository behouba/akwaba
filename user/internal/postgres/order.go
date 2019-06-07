package postgres

import (
	"log"

	"github.com/behouba/akwaba"
)

// SaveOrder save order
func (d *UserDB) SaveOrder(order *akwaba.Order) (err error) {
	err = d.db.QueryRow(
		`INSERT INTO delivery_order 
		(payment_type_id, cost, sender_full_name, sender_phone, 
			sender_city_id, sender_address, receiver_full_name, receiver_phone, 
			receiver_city_id, receiver_address, note, nature, weight_interval_id)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) RETURNING id;`,
		order.PaymentType.ID, order.ComputeCost(), order.Sender.FullName,
		order.Sender.Phone, order.Sender.City.ID, order.Sender.Address,
		order.Receiver.FullName, order.Receiver.Phone, order.Receiver.City.ID,
		order.Receiver.Address, order.Note, order.Nature, order.WeightInterval.ID,
	).Scan(&order.ID)
	return
}

func (d *UserDB) SaveCustomerOrder(order *akwaba.Order, userID int) (err error) {
	err = d.db.QueryRow(
		`INSERT INTO delivery_order 
		(payment_type_id, cost, sender_full_name, sender_phone, 
			sender_city_id, sender_address, receiver_full_name, receiver_phone, 
			receiver_city_id, receiver_address, note, nature, weight_interval_id, customer_id)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) RETURNING id;`,
		order.PaymentType.ID, order.ComputeCost(), order.Sender.FullName,
		order.Sender.Phone, order.Sender.City.ID, order.Sender.Address,
		order.Receiver.FullName, order.Receiver.Phone, order.Receiver.City.ID,
		order.Receiver.Address, order.Note, order.Nature, order.WeightInterval.ID, userID,
	).Scan(&order.ID)
	return
}

// CompleteOrder function complete order information
func (d *UserDB) CompleteOrder(order *akwaba.Order) (err error) {
	order.Sender.City.Name, err = d.cityNameByID(order.Sender.City.ID)
	if err != nil {
		return
	}
	order.Receiver.City.Name, err = d.cityNameByID(order.Receiver.City.ID)
	if err != nil {
		return
	}
	order.ComputeCost()
	order.WeightInterval.Name, err = d.intervalNameByID(order.WeightInterval.ID)
	if err != nil {
		return
	}
	order.PaymentType.Name, err = d.paymentTypeNameByID(order.PaymentType.ID)
	if err != nil {
		return
	}
	return
}

func (d *UserDB) cityNameByID(id int) (name string, err error) {
	err = d.db.QueryRow("SELECT name FROM city WHERE id=$1",
		id,
	).Scan(&name)
	return
}

func (d *UserDB) intervalNameByID(id int) (name string, err error) {
	err = d.db.QueryRow("SELECT name FROM weight_interval WHERE id=$1",
		id,
	).Scan(&name)
	return
}

func (d *UserDB) paymentTypeNameByID(id int) (name string, err error) {
	err = d.db.QueryRow("SELECT name FROM payment_type WHERE id=$1",
		id,
	).Scan(&name)
	return
}

// CancelOrder update order state to "canceled"
func (d *UserDB) CancelOrder(orderID, userID int) (id int, err error) {
	// Will check ownership of user before performing modification
	// on order state in database
	err = d.db.QueryRow(
		`UPDATE delivery_order SET state_id=$1 WHERE id=$2 AND customer_id=$3 RETURNING id`,
		akwaba.OrderStateCanceled, orderID, userID,
	).Scan(&id)
	if err == nil {
		log.Printf("User %d just canceled order %d...", userID, orderID)
	}
	return
}

// Track method take an order id and return current trace data of order with error
func (d *UserDB) Track(userID, orderID int) (oTrace akwaba.Order, err error) {
	if userID != 0 {
		log.Printf("Retriving order tracking by user %d for order %d info from database...\n", userID, orderID)
		return
	}
	log.Printf("Retriving order tracking by unknow user for order %d info from database...\n", orderID)
	return
}

func (d *UserDB) ActiveOrders(userID int) (orders []akwaba.Order, err error) {
	rows, err := d.db.Query(
		`SELECT
			delivery_order.id, payment_type.name as payment_type, cost, 
			sender_full_name, sender_phone, sender_city.name as sender_city, 
			sender_address, receiver_full_name, receiver_phone, 
			receiver_city.name  as receiver_city, receiver_address, note, 
			nature,weight_interval.name as weight_interval, created_at,
			state_id, order_state.name as order_state
		FROM delivery_order
		LEFT JOIN order_state ON
			delivery_order.state_id = order_state.id
		LEFT JOIN city as sender_city ON
			delivery_order.sender_city_id = sender_city.id
		LEFT JOIN city as receiver_city ON
			delivery_order.receiver_city_id = receiver_city.id
		LEFT JOIN payment_type ON
			delivery_order.payment_type_id = payment_type.id
		LEFT JOIN weight_interval ON
			delivery_order.weight_interval_id = weight_interval.id
		WHERE customer_id=$1 AND (state_id=$2 OR state_id=$3)
		ORDER BY created_at DESC;`,
		userID, akwaba.OrderStateWaitingConfirmation, akwaba.OrderStateInProcessing,
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

func (d *UserDB) ArchivedOrders(userID int) (orders []akwaba.Order, err error) {
	rows, err := d.db.Query(
		`SELECT
			delivery_order.id, payment_type.name as payment_type, cost, 
			sender_full_name, sender_phone, sender_city.name as sender_city, 
			sender_address, receiver_full_name, receiver_phone, 
			receiver_city.name  as receiver_city, receiver_address, note, 
			nature,weight_interval.name as weight_interval, created_at,
			state_id, order_state.name as order_state
		FROM delivery_order
		LEFT JOIN order_state ON
			delivery_order.state_id = order_state.id
		LEFT JOIN city as sender_city ON
			delivery_order.sender_city_id = sender_city.id
		LEFT JOIN city as receiver_city ON
			delivery_order.receiver_city_id = receiver_city.id
		LEFT JOIN payment_type ON
			delivery_order.payment_type_id = payment_type.id
		LEFT JOIN weight_interval ON
			delivery_order.weight_interval_id = weight_interval.id
		WHERE customer_id=$1 AND (state_id=$2 OR state_id=$3)
		ORDER BY created_at DESC;`,
		userID, akwaba.OrderStateCanceled, akwaba.OrderStateClosed,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order

		err = rows.Scan(
			&o.ID, &o.PaymentType.Name, &o.Cost, &o.Sender.FullName,
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
