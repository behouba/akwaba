package main

import (
	"io/ioutil"
	"log"
	"os"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/postgres/adminapi/employees"
	"github.com/behouba/akwaba/postgres/adminapi/order"
	"github.com/behouba/akwaba/postgres/adminapi/shipment"
	"github.com/behouba/akwaba/postgres/adminapi/user"
	"github.com/behouba/akwaba/postgres/location"
	"github.com/behouba/akwaba/postgres/pricing"

	"github.com/behouba/akwaba/adminapi"
	"github.com/behouba/akwaba/adminapi/jwt"
	"github.com/behouba/akwaba/postgres"
	"gopkg.in/yaml.v2"
)

type config struct {
	Port       string           `yaml:"port"`
	DB         *postgres.Config `yaml:"database"`
	HSecretKey string           `yaml:"hSecretKey"`
	OSecretKey string           `yaml:"oSecretKey"`
	MapAPIKey  string           `yaml:"mapApiKey"`
}

var configFile = "~/.config/prod-config.yml"

func main() {
	var c config

	if len(os.Args) > 1 {
		configFile = os.Args[1]
	}

	bs, err := ioutil.ReadFile(configFile)
	if err != nil {
		log.Fatal(err)
	}
	err = yaml.Unmarshal(bs, &c)
	if err != nil {
		log.Fatal(err)
	}

	db, err := postgres.Open(c.DB)
	if err != nil {
		log.Fatal(err)
	}
	ordersManagerJWT := jwt.NewAuthenticator(c.HSecretKey)
	shipemntsManagerJWT := jwt.NewAuthenticator(c.OSecretKey)

	ordersManagerAuth, err := employees.New(db, akwaba.OrdersManagerPositionID)
	if err != nil {
		log.Fatal(err)
	}

	shipmentsManagerAuth, err := employees.New(db, akwaba.ShipmentsManagerPositionID)
	if err != nil {
		log.Fatal(err)
	}

	pricingService, err := pricing.New(db, c.MapAPIKey)
	if err != nil {
		log.Fatal(err)
	}

	locationService, err := location.New(db)
	if err != nil {
		log.Fatal(err)
	}
	orderStore, err := order.New(db)
	if err != nil {
		log.Fatal(err)
	}
	shipmentStore, err := shipment.New(db)
	if err != nil {
		log.Fatal(err)
	}
	userStore, err := user.New(db)
	if err != nil {
		log.Fatal(err)
	}
	engine, err := adminapi.SetupAdminAPIEngine(
		ordersManagerJWT, shipemntsManagerJWT, orderStore,
		ordersManagerAuth, shipmentsManagerAuth, userStore,
		shipmentStore, pricingService, locationService,
	)
	engine.Run(c.Port)
}
