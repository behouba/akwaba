package postgres

import (
	"fmt"
	"log"
	"time"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// DB hold database connection for users
const dbURIPattern = "host=%s port=%d user=%s password=%s dbname=%s sslmode=disable connect_timeout=100"

var (
	cities             akwaba.KeyVal
	paymentOptions     akwaba.KeyVal
	shipmentCategories akwaba.KeyVal
	orderStates        akwaba.KeyVal
)

type Config struct {
	Host     string `yaml:"host"`
	Port     int    `yaml:"port"`
	User     string `yaml:"user"`
	DBName   string `yaml:"dbName"`
	Password string `yaml:"password"`
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func Open(c *Config) (db *sqlx.DB, err error) {
	// will open database connection here
	// each server should have it own database user with corresponding rights on database
	uri := fmt.Sprintf(
		dbURIPattern,
		c.Host, c.Port, c.User, c.Password, c.DBName,
	)
	db, err = sqlx.Connect("postgres", uri)
	if err != nil {
		log.Println(err)
		return
	}

	db.SetMaxOpenConns(5)
	db.SetConnMaxLifetime(time.Minute * 1)

	cities, err = queryCities(db)
	if err != nil {
		return
	}
	shipmentCategories, err = queryShipmentCategorys(db)
	if err != nil {
		return
	}
	paymentOptions, err = queryPaymentOptions(db)
	if err != nil {
		return
	}
	orderStates, err = queryOrderStates(db)
	if err != nil {
		return
	}
	return
}

func queryCities(db *sqlx.DB) (cities akwaba.KeyVal, err error) {
	cities = make(akwaba.KeyVal)
	rows, err := db.Query(
		`SELECT city_id, name from cities ORDER BY name`,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var c akwaba.City
		err = rows.Scan(&c.ID, &c.Name)
		if err != nil {
			return
		}
		cities[c.ID] = c.Name
	}
	log.Println(cities)
	return
}

func queryShipmentCategorys(db *sqlx.DB) (cat akwaba.KeyVal, err error) {
	cat = make(akwaba.KeyVal)
	rows, err := db.Query(
		`SELECT shipment_category_id, name, min_cost, max_cost from shipment_categories order by shipment_category_id`,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var c akwaba.ShipmentCategory
		err = rows.Scan(&c.ID, &c.Name, &c.MinCost, &c.MaxCost)
		if err != nil {
			return
		}
		cat[c.ID] = c.Name
	}
	return
}

func queryPaymentOptions(db *sqlx.DB) (po akwaba.KeyVal, err error) {
	po = make(akwaba.KeyVal)
	rows, err := db.Query(
		`SELECT payment_option_id, name from payment_options order by payment_option_id`,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.PaymentOption
		err = rows.Scan(&p.ID, &p.Name)
		if err != nil {
			return
		}
		po[p.ID] = p.Name
	}
	return
}

func queryOrderStates(db *sqlx.DB) (states akwaba.KeyVal, err error) {
	states = make(akwaba.KeyVal)
	rows, err := db.Query(
		`SELECT order_state_id, name from order_states order by order_state_id`,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.OrderState
		err = rows.Scan(&o.ID, &o.Name)
		if err != nil {
			return
		}
		states[o.ID] = o.Name
	}
	return
}

func Cities() akwaba.KeyVal {
	return cities
}

func PaymentOptions() akwaba.KeyVal {
	return paymentOptions
}

func ShipmentCategories() akwaba.KeyVal {
	return shipmentCategories
}

func OrderStates() akwaba.KeyVal {
	return orderStates
}
