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
	cities             []akwaba.City
	paymentOptions     []akwaba.PaymentOption
	shipmentCategories []akwaba.ShipmentCategory
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

	cities, err = akwaba.Cities(db)
	if err != nil {
		return
	}
	shipmentCategories, err = akwaba.ShipmentCategorys(db)
	if err != nil {
		return
	}
	paymentOptions, err = akwaba.PaymentType(db)
	if err != nil {
		return
	}
	return
}

func Cities() []akwaba.City {
	return cities
}

func PaymentOptions() []akwaba.PaymentOption {
	return paymentOptions
}

func ShipmentCategories() []akwaba.ShipmentCategory {
	return shipmentCategories
}
