package postgres

import (
	"log"

	"github.com/behouba/akwaba"
	"github.com/behouba/dsapi"
)

// SaveOrder save order
func (d *UserDB) SaveOrder(order *dsapi.Order) (err error) {
	log.Println("ORDER SAVED TO DATABASE...")
	return
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
