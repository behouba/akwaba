package pricing

import (
	"database/sql"

	"github.com/jmoiron/sqlx"
)

const (
	selectAreaSQL = "" +
		"SELECT area_id, name, city_id FROM areas WHERE name ILIKE $1 || '%' ORDER BY name ASC LIMIT 100"

	selectAreaAlternativeSQL = "" +
		"SELECT area_id, name, city_id FROM areas WHERE name ILIKE '%' || $1 || '%' ORDER BY name ASC LIMIT 100"

	selectMinMaxCostSQL = "SELECT min_cost, max_cost FROM shipment_categories WHERE shipment_category_id=$1"

	selectPaymentOptionsSQL = "" +
		"SELECT payment_option_id, name FROM payment_options ORDER BY payment_option_id"
	selectShipmentCategoriesSQL = "" +
		"SELECT shipment_category_id, name, min_cost, max_cost " +
		"FROM shipment_categories order by shipment_category_id"
)

type statements struct {
	selectAreaStmt               *sql.Stmt
	selectAreaAlternativeStmt    *sql.Stmt
	selectMinMaxCostStmt         *sql.Stmt
	selectPaymentOptionsStmt     *sql.Stmt
	selectShipmentCategoriesStmt *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {

	if s.selectAreaStmt, err = db.Prepare(selectAreaSQL); err != nil {
		return
	}
	if s.selectAreaAlternativeStmt, err = db.Prepare(selectAreaAlternativeSQL); err != nil {
		return
	}
	if s.selectMinMaxCostStmt, err = db.Prepare(selectMinMaxCostSQL); err != nil {
		return
	}
	if s.selectPaymentOptionsStmt, err = db.Prepare(selectPaymentOptionsSQL); err != nil {
		return
	}
	if s.selectShipmentCategoriesStmt, err = db.Prepare(selectShipmentCategoriesSQL); err != nil {
		return
	}
	return
}
