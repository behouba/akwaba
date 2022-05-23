package tracking

import (
	"database/sql"

	"github.com/jmoiron/sqlx"
)

const (
	selectShipmentSQL = "" +
		"SELECT shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id, " +
		"sender_area, sender_address, recipient_name, recipient_phone, recipient_area_id, " +
		"recipient_area, recipient_address, time_created, shipment_category_id, shipment_category, " +
		"cost, shipment_state_id, shipment_state, weight, payment_option_id, payment_option, " +
		"distance, nature FROM full_shipments "

	selectShipmentByIDSQL = selectShipmentSQL + "WHERE shipment_id=$1;"

	selectShipmentByOrderIDSQL = selectShipmentSQL + "WHERE order_id=$1;"

	selectShipmentTrackingSQL = "" +
		"SELECT shipment_state, time_inserted, city, area FROM shipments_tracking WHERE shipment_id=$1 " +
		"ORDER BY time_inserted DESC"
)

type statements struct {
	selectShipmentByIDStmt      *sql.Stmt
	selectShipmentByOrderIDStmt *sql.Stmt
	selectShipmentTrackingStmt  *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {
	if s.selectShipmentByIDStmt, err = db.Prepare(selectShipmentByIDSQL); err != nil {
		return
	}
	if s.selectShipmentByOrderIDStmt, err = db.Prepare(selectShipmentByOrderIDSQL); err != nil {
		return
	}
	if s.selectShipmentTrackingStmt, err = db.Prepare(selectShipmentTrackingSQL); err != nil {
		return
	}
	return
}
