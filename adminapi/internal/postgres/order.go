package postgres

import (
	"database/sql"

	"github.com/behouba/dsapi"
)

// OrderStore implement the AdminOrderer interface
type OrderStore struct {
	Db *sql.DB
}

// Pending retreive all pending order related to the employee office id
func (o *OrderStore) Pending(officeID int) (orders []dsapi.Order, err error) {
	orders = append(orders, dsapi.Order{})
	return
}

// Get method retreive order by id from database
func (o *OrderStore) Get(id int) (order dsapi.Order, err error) {
	order.ID = id
	return
}

// Confirm update order in database and mark it as confirmed
func (o *OrderStore) Confirm(id int) (err error) {
	return
}

// Cancel update order in database and mark it as cancel
func (o *OrderStore) Cancel(id int) (err error) {
	return
}

// Save save order created by admin agent into database
func (o *OrderStore) Save(order *dsapi.Order) (err error) {
	return
}

// AddNewTrackingStep take a pointer to track struct and add new tracking
// step into database for corresponding order
func (a *AdminDB) AddNewTrackingStep(track *dsapi.Track) (err error) {
	return
}
