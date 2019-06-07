package akwaba

import (
	"database/sql"
	"log"
)

func GetAllCities(db *sql.DB) (cities []City, err error) {
	rows, err := db.Query("SELECT id, name, office_id from city ORDER BY name")
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

func GetWeightIntervals(db *sql.DB) (w []WeightInterval, err error) {
	rows, err := db.Query("SELECT id, name from weight_interval order by id")
	if err != nil {
		return
	}
	for rows.Next() {
		var i WeightInterval
		err = rows.Scan(&i.ID, &i.Name)
		if err != nil {
			log.Println(err)
		}
		w = append(w, i)
	}
	return
}

func GetPaymentType(db *sql.DB) (pt []PaymentType, err error) {
	rows, err := db.Query("SELECT id, name from payment_type order by id")
	if err != nil {
		return
	}
	for rows.Next() {
		var p PaymentType
		err = rows.Scan(&p.ID, &p.Name)
		if err != nil {
			log.Println(err)
		}
		pt = append(pt, p)
	}
	return
}
