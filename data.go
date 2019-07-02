package akwaba

import (
	"github.com/jmoiron/sqlx"

	"log"
)

func Cities(db *sqlx.DB) (cities []City, err error) {
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
		cities = append(cities, c)
	}
	log.Println(cities)
	return
}

func ShipmentCategorys(db *sqlx.DB) (cat []ShipmentCategory, err error) {
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
		cat = append(cat, c)
	}
	return
}

func PaymentType(db *sqlx.DB) (po []PaymentOption, err error) {
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
		po = append(po, p)
	}
	return
}
