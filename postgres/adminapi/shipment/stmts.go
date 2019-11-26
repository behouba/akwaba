package shipment

import (
	"database/sql"

	"github.com/jmoiron/sqlx"
)

const (
	selectShipmentsSQL = "" +
		"SELECT shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id, " +
		"sender_area, sender_address, recipient_name, recipient_phone, recipient_area_id, " +
		"recipient_area, recipient_address, time_created, shipment_category_id, " +
		"shipment_category, cost, shipment_state_id, shipment_state, weight, payment_option_id, " +
		"payment_option, distance, nature FROM full_shipments "

	selectShipmentsToPickupSQL = "" +
		"SELECT shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id, " +
		"sender_area, sender_address, recipient_name, recipient_phone, recipient_area_id, " +
		"recipient_area, recipient_address, time_created, shipment_category_id, " +
		"shipment_category, cost, shipment_state_id, shipment_state, payment_option_id, " +
		"payment_option, distance, nature FROM full_shipments " +
		"WHERE pickup_office_id=$1 AND shipment_state_id=$2;"

	selectShipmentsInStockSQL = selectShipmentsSQL + "WHERE current_office_id=$1"

	selectShipmentToDeliverSQL = selectShipmentsSQL +
		"WHERE delivery_office_id=$1 AND current_office_id=$2;"

	selectCurrentOfficeIDAndStateIDSQL = "" +
		"SELECT current_office_id, shipment_state_id FROM shipments WHERE shipment_id=$1"
	selectOfficesIDsStateIDSQL = "" +
		"SELECT shipment_state_id, current_office_id, delivery_office_id " +
		"FROM full_shipments WHERE shipment_id=$1 AND current_office_id=$2"
	selectOfficesIDsStateIDAndOrderIDSQL = "" +
		"SELECT order_id, shipment_state_id, current_office_id, delivery_office_id " +
		"FROM full_shipments WHERE shipment_id=$1 AND current_office_id=$2"

	shipmentPickedUpSQL = "" +
		"UPDATE shipments SET weight=$1, shipment_state_id=$2, current_office_id=$3 WHERE shipment_id=$4"

	insertShipmentHistorySQL = "" +
		"INSERT INTO shipments_history (shipment_id, shipment_state_id, area_id) VALUES ($1, $2, $3)"

	checkInShipmentSQL = "" +
		"UPDATE shipments SET current_office_id=$1, shipment_state_id=$2 WHERE shipment_id=$3"
	checkOutShipmentSQL = "" +
		"UPDATE shipments SET current_office_id=null, shipment_state_id=$1 " +
		"WHERE shipment_id=$2 AND current_office_id=$3"

	closeOrderSQL = "UPDATE orders SET order_state_id=$1, time_closed=NOW() WHERE order_id=$2"

	failedDeliverySQL = "" +
		"UPDATE shipments SET shipment_state_id=$1 WHERE shipment_id=$2 AND current_office_id=$3"
)

type statements struct {
	selectShipmentsToPickupStmt           *sql.Stmt
	selectShipmentsInStockStmt            *sql.Stmt
	selectShipmentToDeliverStmt           *sql.Stmt
	selectCurrentOfficeIDAndStateIDStmt   *sql.Stmt
	selectOfficesIDsStateIDStmt           *sql.Stmt
	selectOfficesIDsStateIDAndOrderIDStmt *sql.Stmt
	shipmentPickedUpStmt                  *sql.Stmt
	insertShipmentHistoryStmt             *sql.Stmt
	checkInShipmentStmt                   *sql.Stmt
	checkOutShipmentStmt                  *sql.Stmt
	closeOrderStmt                        *sql.Stmt
	failedDeliveryStmt                    *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {
	if s.selectShipmentsToPickupStmt, err = db.Prepare(selectShipmentsToPickupSQL); err != nil {
		return
	}
	if s.selectShipmentsInStockStmt, err = db.Prepare(selectShipmentsInStockSQL); err != nil {
		return
	}
	if s.selectShipmentToDeliverStmt, err = db.Prepare(selectShipmentToDeliverSQL); err != nil {
		return
	}
	if s.selectCurrentOfficeIDAndStateIDStmt, err = db.Prepare(
		selectCurrentOfficeIDAndStateIDSQL,
	); err != nil {
		return
	}
	if s.selectOfficesIDsStateIDStmt, err = db.Prepare(selectOfficesIDsStateIDSQL); err != nil {
		return
	}
	if s.selectOfficesIDsStateIDAndOrderIDStmt, err = db.Prepare(
		selectOfficesIDsStateIDAndOrderIDSQL,
	); err != nil {
		return
	}
	if s.shipmentPickedUpStmt, err = db.Prepare(shipmentPickedUpSQL); err != nil {
		return
	}
	if s.insertShipmentHistoryStmt, err = db.Prepare(insertShipmentHistorySQL); err != nil {
		return
	}
	if s.checkInShipmentStmt, err = db.Prepare(checkInShipmentSQL); err != nil {
		return
	}
	if s.checkOutShipmentStmt, err = db.Prepare(checkOutShipmentSQL); err != nil {
		return
	}
	if s.closeOrderStmt, err = db.Prepare(closeOrderSQL); err != nil {
		return
	}
	if s.failedDeliveryStmt, err = db.Prepare(failedDeliverySQL); err != nil {
		return
	}
	return
}
