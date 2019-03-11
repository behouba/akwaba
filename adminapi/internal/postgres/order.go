package postgres

import (
	"github.com/behouba/dsapi"
)

// PendingOrders retreive all pending order related to the employee office id
func (a *AdminDB) PendingOrders(officeID int) (orders []dsapi.Order, err error) {
	orders = append(orders, dsapi.Order{})
	return
}
