package postgres

import (
	"github.com/behouba/dsapi"
)

// PendingOrders retreive all pending order related to the employee office id
func (a *AdminDB) PendingOrders(officeID int) (orders []dsapi.Order, err error) {
	orders = append(orders, dsapi.Order{})
	return
}

// Order method retreive order by id from database
func (a *AdminDB) Order(id int) (order dsapi.Order, err error) {
	order.ID = id
	return
}

// ConfirmOrder update order in database and mark it as confirmed
func (a *AdminDB) ConfirmOrder(id int) (err error) {
	return
}

// CancelOrder update order in database and mark it as cancel
func (a *AdminDB) CancelOrder(id int) (err error) {
	return
}

// SaveOrder save order created by admin agent into database
func (a *AdminDB) SaveOrder(order *dsapi.Order) (err error) {
	return
}

// AddNewTrackingStep take a pointer to track struct and add new tracking
// step into database for corresponding order
func (a *AdminDB) AddNewTrackingStep(track *dsapi.Track) (err error) {
	return
}
