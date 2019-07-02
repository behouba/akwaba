package postgres

import (
	"log"
	"time"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// DB hold database connection for users
type DB struct {
	db                 *sqlx.DB
	Auth               Authenticator
	CustomerStore      CustomerStorage
	Cities             []akwaba.City
	ShipmentCategories []akwaba.ShipmentCategory
	PaymentOptions     []akwaba.PaymentOption
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func Open(uri string) (db *sqlx.DB, err error) {
	// will open database connection here
	// each server should have it own database user with corresponding rights on database
	db, err = sqlx.Connect("postgres", uri)
	if err != nil {
		log.Println(err)
		return
	}

	db.SetMaxOpenConns(5)
	db.SetConnMaxLifetime(time.Minute * 1)

	// d.Cities, err = akwaba.Cities(db)
	// if err != nil {
	// 	return
	// }
	// d.ShipmentCategories, err = akwaba.ShipmentCategorys(db)
	// if err != nil {
	// 	return
	// }
	// d.PaymentOptions, err = akwaba.PaymentType(db)
	// if err != nil {
	// 	return
	// }
	return
}
