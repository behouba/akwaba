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
	citiesMap             akwaba.KeyVal
	cities                []akwaba.City
	paymentOptionsMap     akwaba.KeyVal
	paymentOptions        []akwaba.PaymentOption
	shipmentCategoriesMap akwaba.KeyVal
	shipmentCategories    []akwaba.ShipmentCategory
	orderStatesMap        akwaba.KeyVal
	orderStates           []akwaba.OrderState
	areas                 []akwaba.Area
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

	citiesMap, cities, err = queryCities(db)
	if err != nil {
		return
	}
	shipmentCategoriesMap, shipmentCategories, err = queryShipmentCategorys(db)
	if err != nil {
		return
	}
	paymentOptionsMap, paymentOptions, err = queryPaymentOptions(db)
	if err != nil {
		return
	}
	orderStatesMap, orderStates, err = queryOrderStates(db)
	if err != nil {
		return
	}
	areas, err = queryAreas(db)
	if err != nil {
		return
	}
	return
}

func queryCities(db *sqlx.DB) (citiesMap akwaba.KeyVal, citiesSlice []akwaba.City, err error) {
	citiesMap = make(akwaba.KeyVal)
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
		citiesMap[c.ID] = c.Name
		citiesSlice = append(citiesSlice, c)
	}
	return
}

func queryShipmentCategorys(db *sqlx.DB) (catMap akwaba.KeyVal, cats []akwaba.ShipmentCategory, err error) {
	catMap = make(akwaba.KeyVal)
	rows, err := db.Query(
		`SELECT 
		shipment_category_id, name, min_cost, max_cost 
		FROM shipment_categories 
		order by shipment_category_id`,
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
		cats = append(cats, c)
		catMap[c.ID] = c.Name
	}
	return
}

func queryPaymentOptions(db *sqlx.DB) (poMap akwaba.KeyVal, po []akwaba.PaymentOption, err error) {
	poMap = make(akwaba.KeyVal)
	rows, err := db.Query(
		`SELECT 
		payment_option_id, name 
		FROM payment_options 
		ORDER BY payment_option_id`,
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
		po = append(po, p)
		poMap[p.ID] = p.Name
	}
	return
}

func queryOrderStates(db *sqlx.DB) (statesMap akwaba.KeyVal, states []akwaba.OrderState, err error) {
	statesMap = make(akwaba.KeyVal)
	rows, err := db.Query(
		`SELECT 
		order_state_id, name 
		FROM order_states ORDER BY  order_state_id`,
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
		states = append(states, o)
		statesMap[o.ID] = o.Name
	}
	return
}

func queryAreas(db *sqlx.DB) (areas []akwaba.Area, err error) {
	rows, err := db.Query("SELECT area_id, name, city_id FROM areas")
	if err != nil {
		return
	}
	for rows.Next() {
		var a akwaba.Area
		err = rows.Scan(&a.ID, &a.Name, &a.CityID)
		if err != nil {
			return
		}
		areas = append(areas, a)
	}
	return
}

func CitiesMap() akwaba.KeyVal {
	return citiesMap
}

func PaymentOptionsMap() akwaba.KeyVal {
	return paymentOptionsMap
}

func ShipmentCategoriesMap() akwaba.KeyVal {
	return shipmentCategoriesMap
}
func OrderStatesMap() akwaba.KeyVal {
	return orderStatesMap
}

func Cities() []akwaba.City {
	return cities
}
func OrderStates() []akwaba.OrderState {
	return orderStates
}

type SytemDataStore struct {
}

func NewSystemData() *SytemDataStore {
	return &SytemDataStore{}
}

func (s *SytemDataStore) PaymentOptions() []akwaba.PaymentOption {
	return paymentOptions
}

func (s *SytemDataStore) ShipmentCategories() []akwaba.ShipmentCategory {
	return shipmentCategories
}

func (s *SytemDataStore) Areas() []akwaba.Area {
	return areas
}
