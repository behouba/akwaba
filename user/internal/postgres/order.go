package postgres

import (
	"log"

	"github.com/behouba/akwaba"
)

// SaveOrder save order
func (d *UserDB) SaveOrder(order *akwaba.Order) (err error) {
	err = d.DB.QueryRow(
		`INSERT INTO "order" 
		(payment_type_id, cost, sender_full_name, sender_phone, 
			sender_city_id, sender_address, receiver_full_name, receiver_phone, 
			receiver_city_id, receiver_address, note, nature)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING id;`,
		order.PaymentType.ID, order.ComputeCost(), order.Sender.FullName,
		order.Sender.Phone, order.Sender.City.ID, order.Sender.Address,
		order.Receiver.FullName, order.Receiver.Phone, order.Receiver.City.ID,
		order.Receiver.Address, order.Note, order.Nature,
	).Scan(&order.ID)
	return
}

// CompleteOrder function complete order information
func (d *UserDB) CompleteOrder(order *akwaba.Order) (err error) {
	order.Sender.City.Name = "Cocody"
	order.Receiver.City.Name = "Adjamé"
	// order.ComputeCost()
	order.Cost = 3500.0
	order.WeightInterval.Name = ">1 - 5kg"
	order.PaymentType.Name = "Paiement cash à la collecte"
	return nil
}

// CancelOrder update order state to "canceled"
func (d *UserDB) CancelOrder(userID, orderID int) (err error) {
	// Will check ownership of user before performing modification
	// on order state in database
	log.Printf("User %d just canceled order %d...", userID, orderID)
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
