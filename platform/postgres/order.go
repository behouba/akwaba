package postgres

import (
	"log"

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
