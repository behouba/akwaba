package akwaba

import (
	"github.com/jmoiron/sqlx"

	"log"
)

type KeyVal map[uint8]string

func Cities(db *sqlx.DB) (cities KeyVal, err error) {
	cities = make(KeyVal)
	rows, err := db.Query(
		`SELECT city_id, name, office_id from cities ORDER BY name`,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var c City
		err = rows.Scan(&c.ID, &c.Name, &c.OfficeID)
		if err != nil {
			log.Println(err)
		}
		cities[c.ID] = c.Name
	}
	log.Println(cities)
	return
}

func ShipmentCategorys(db *sqlx.DB) (cat KeyVal, err error) {
	cat = make(KeyVal)
	rows, err := db.Query(
		`SELECT shipment_category_id, name, min_cost, max_cost from shipment_categories order by shipment_category_id`,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var c ShipmentCategory
		err = rows.Scan(&c.ID, &c.Name, &c.MinCost, &c.MaxCost)
		if err != nil {
			log.Println(err)
		}
		cat[c.ID] = c.Name
	}
	return
}

func PaymentType(db *sqlx.DB) (po KeyVal, err error) {
	po = make(KeyVal)
	rows, err := db.Query(
		`SELECT payment_option_id, name from payment_options order by payment_option_id`,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var p PaymentOption
		err = rows.Scan(&p.ID, &p.Name)
		if err != nil {
			log.Println(err)
		}
		po[p.ID] = p.Name
	}
	return
}
