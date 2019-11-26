package orders

import (
	"database/sql"

	"github.com/jmoiron/sqlx"
)

const (
	selectOrdersWithOffsetSQL = "" +
		"SELECT * FROM full_orders WHERE user_id=$1 ORDER BY time_created DESC LIMIT 50 OFFSET $2"

	selectOrderSQL = "" +
		"select * from full_orders WHERE order_id=$1 AND user_id=$2 ORDER BY time_created DESC"

	countPendingOrdersSQL = "SELECT COUNT(*) FROM orders WHERE user_id=$1 AND order_state_id=$2"

	insertOrderSQL = "" +
		"INSERT INTO orders " +
		"(user_id, sender_name, sender_phone, sender_area_id, sender_address, recipient_name, " +
		"recipient_phone, recipient_area_id, recipient_address, shipment_category_id, nature, " +
		"payment_option_id, cost, distance, order_state_id) " +
		"VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15) RETURNING order_id"

	insertOrderStateChangeSQL = "INSERT INTO orders_history (order_id, order_state_id) VALUES ($1, $2)"

	cancelOrderSQL = "UPDATE orders SET order_state_id=$1 WHERE order_id=$2 AND order_state_id=$3"
)

type statements struct {
	selectOrdersWithOffsetStmt *sql.Stmt
	selectOrderStmt            *sql.Stmt
	countPendingOrdersStmt     *sql.Stmt
	insertOrderStmt            *sql.Stmt
	insertOrderStateChangeStmt *sql.Stmt
	cancelOrderStmt            *sql.Stmt
}

func (o *statements) prepare(db *sqlx.DB) (err error) {
	if o.selectOrdersWithOffsetStmt, err = db.Prepare(selectOrdersWithOffsetSQL); err != nil {
		return
	}

	if o.selectOrderStmt, err = db.Prepare(selectOrderSQL); err != nil {
		return
	}
	if o.countPendingOrdersStmt, err = db.Prepare(countPendingOrdersSQL); err != nil {
		return
	}
	if o.insertOrderStmt, err = db.Prepare(insertOrderSQL); err != nil {
		return
	}
	if o.insertOrderStateChangeStmt, err = db.Prepare(insertOrderStateChangeSQL); err != nil {
		return
	}
	if o.cancelOrderStmt, err = db.Prepare(cancelOrderSQL); err != nil {
		return
	}
	return
}
