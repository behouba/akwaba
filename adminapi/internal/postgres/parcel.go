package postgres

import (
	"database/sql"

	"github.com/behouba/dsapi"
)

const (
	pStateWaitingPickUp      = 1
	pStateSupported          = 2
	pStateInTransportation   = 3
	pStateDelivered          = 4
	pStateWaitingNewDelivery = 5
)

type ParcelStore struct {
	DB *sql.DB
}

func (p *ParcelStore) Track(orderID, officeID int) (events []dsapi.Event, err error) {
	return
}
