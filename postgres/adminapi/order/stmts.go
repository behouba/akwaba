package order

import (
	"database/sql"

	"github.com/jmoiron/sqlx"
)

const (
	selectActiveOrdersSQL = "" +
		"SELECT * from full_orders WHERE order_state_id=$1 OR order_state_id=$2 ORDER BY time_created DESC"
	selectOrderDataSQL = "" +
		"SELECT order_id, user_id, sender_name, sender_phone,sender_area_id, " +
		"sender_address, recipient_name, recipient_phone, recipient_area_id, " +
		"recipient_address, shipment_category_id, nature, payment_option_id, cost, distance " +
		"FROM orders WHERE order_id=$1"

	selectClosedOrdersByDateSQL = "" +
		"SELECT * from full_orders WHERE time_closed::date = date($1) ORDER BY time_created DESC"

	selectOrderStateIDSQL = "SELECT order_state_id FROM orders WHERE order_id=$1"

	selectShipmentIDAndStateSQL = "SELECT shipment_id, shipment_state_id FROM shipments WHERE order_id=$1"

	insertNewOrderSQL = "" +
		"INSERT INTO orders (sender_name, sender_phone, sender_area_id, sender_address, recipient_name, " +
		"recipient_phone, recipient_area_id, recipient_address, " +
		"shipment_category_id, nature, payment_option_id, cost, distance, order_state_id) " +
		"VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) RETURNING order_id"
	insertNewShipmentSQL = "" +
		"INSERT INTO shipments (order_id, user_id, sender_name, sender_phone, sender_area_id, " +
		"sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_address, " +
		"shipment_category_id,cost, nature, payment_option_id, distance, shipment_state_id) " +
		"VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16) " +
		"RETURNING shipment_id"

	insertShipmentHistorySQL = "" +
		"INSERT INTO shipments_history (shipment_id, shipment_state_id, area_id) VALUES ($1, $2, $3)"
	insertOrderHistorySQL = "" +
		"INSERT INTO orders_history (order_id, order_state_id) VALUES ($1, $2)"

	cancelPendingOrderSQL = "UPDATE orders SET order_state_id=$1 WHERE order_id=$2 AND order_state_id=$3"
	cancelOrderSQL        = "UPDATE orders SET order_state_id=$1, time_closed=NOW() WHERE order_id=$2"

	updateOrderStateSQL = "UPDATE orders SET order_state_id=$1 WHERE order_id=$2"
)

type statements struct {
	selectActiveOrdersStmt       *sql.Stmt
	selectOrderDataStmt          *sql.Stmt
	selectClosedOrdersByDateStmt *sql.Stmt
	selectOrderStateIDStmt       *sql.Stmt
	selectShipmentIDAndStateStmt *sql.Stmt
	insertNewOrderStmt           *sql.Stmt
	insertNewShipmentStmt        *sql.Stmt
	insertShipmentHistoryStmt    *sql.Stmt
	insertOrderHistoryStmt       *sql.Stmt
	cancelPendingOrderStmt       *sql.Stmt
	cancelOrderStmt              *sql.Stmt
	updateOrderStateStmt         *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {
	if s.selectActiveOrdersStmt, err = db.Prepare(selectActiveOrdersSQL); err != nil {
		return
	}
	if s.selectOrderDataStmt, err = db.Prepare(selectOrderDataSQL); err != nil {
		return
	}
	if s.selectClosedOrdersByDateStmt, err = db.Prepare(selectClosedOrdersByDateSQL); err != nil {
		return
	}
	if s.selectOrderStateIDStmt, err = db.Prepare(selectOrderStateIDSQL); err != nil {
		return
	}
	if s.selectShipmentIDAndStateStmt, err = db.Prepare(selectShipmentIDAndStateSQL); err != nil {
		return
	}
	if s.insertNewOrderStmt, err = db.Prepare(insertNewOrderSQL); err != nil {
		return
	}
	if s.insertNewShipmentStmt, err = db.Prepare(insertNewShipmentSQL); err != nil {
		return
	}
	if s.insertShipmentHistoryStmt, err = db.Prepare(insertShipmentHistorySQL); err != nil {
		return
	}
	if s.insertOrderHistoryStmt, err = db.Prepare(insertOrderHistorySQL); err != nil {
		return
	}
	if s.cancelPendingOrderStmt, err = db.Prepare(cancelPendingOrderSQL); err != nil {
		return
	}
	if s.cancelOrderStmt, err = db.Prepare(cancelOrderSQL); err != nil {
		return
	}
	if s.updateOrderStateStmt, err = db.Prepare(updateOrderStateSQL); err != nil {
		return
	}
	return
}
