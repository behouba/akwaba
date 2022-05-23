package mailstore

import (
	"context"
	"database/sql"

	"github.com/jmoiron/sqlx"
)

const (
	selectMailingDataByOrderIDSQL      = "SELECT first_name, email FROM mailing_data_view WHERE order_id=$1"
	selectMailingDataByShipmentIDIDSQL = "SELECT first_name, email FROM mailing_data_view WHERE order_id=$1"
	selectUserNameByEmailSQL           = "SELECT first_name FROM users WHERE email=$1"
)

type statements struct {
	selectMailingDataByOrderIDStmt      *sql.Stmt
	selectMailingDataByShipmentIDIDStmt *sql.Stmt
	selectUserNameByEmailStmt           *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {
	if s.selectMailingDataByOrderIDStmt, err = db.Prepare(selectMailingDataByOrderIDSQL); err != nil {
		return
	}
	if s.selectMailingDataByShipmentIDIDStmt, err = db.Prepare(
		selectMailingDataByShipmentIDIDSQL,
	); err != nil {
		return
	}
	if s.selectUserNameByEmailStmt, err = db.Prepare(selectUserNameByEmailSQL); err != nil {
		return
	}
	return
}

func (s *statements) selectMailingDataByOrderID(ctx context.Context, orderID uint64) (userName, email string, err error) {
	err = s.selectMailingDataByOrderIDStmt.QueryRowContext(
		ctx, orderID,
	).Scan(&userName, &email)
	if err != nil {
		return
	}
	return
}

func (s *statements) selectMailingDataByShipmentID(ctx context.Context, shipmentID uint64) (userName, email string, err error) {
	err = s.selectMailingDataByShipmentIDIDStmt.QueryRowContext(
		ctx, shipmentID,
	).Scan(&userName, &email)
	if err != nil {
		return
	}
	return
}

func (s *statements) selectUserName(ctx context.Context, email string) (userName string, err error) {
	err = s.selectUserNameByEmailStmt.QueryRowContext(
		ctx, email,
	).Scan(&userName)
	if err != nil {
		return
	}
	return
}
