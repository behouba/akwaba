package postgres

import (
	"github.com/jmoiron/sqlx"
)

type ShipmentStateStore struct {
	db *sqlx.DB
}

func NewShipmentStateStore(db *sqlx.DB) *ShipmentStateStore {
	return &ShipmentStateStore{db: db}
}

func (s *ShipmentStateStore) UpdateState(shipmentID uint64, stateID uint8, areaID uint) (err error) {
	_, err = s.db.Exec(
		`UPDATE shipments SET shipment_state_id=$1 WHERE shipment_id=$2`,
		stateID, shipmentID,
	)
	if err != nil {
		return
	}
	_, err = s.db.Exec(
		`INSERT INTO shipments_history 
		(shipment_id, shipment_state_id, area_id) 
		VALUES ($1, $2, $3)`,
		shipmentID, stateID, areaID,
	)
	if err != nil {
		return
	}
	return
}
