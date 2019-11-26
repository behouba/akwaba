package main

import (
	"io/ioutil"
	"log"
	"os"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/adminapi/storage/employees"
	"github.com/behouba/akwaba/adminapi/storage/order"
	"github.com/behouba/akwaba/adminapi/storage/shipment"
	"github.com/behouba/akwaba/storage/location"
	"github.com/behouba/akwaba/storage/pricing"

	"github.com/behouba/akwaba/adminapi"
	"github.com/behouba/akwaba/adminapi/jwt"
	postgres "github.com/behouba/akwaba/storage"
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
		log.Fatal("order Store failed", err)
	}
	shipmentStore, err := shipment.New(db)
	if err != nil {
		log.Fatal("shipment Store failed", err)
	}
	engine, err := adminapi.SetupAdminAPIEngine(
		ordersManagerJWT, shipemntsManagerJWT, orderStore,
		ordersManagerAuth, shipmentsManagerAuth, nil, nil, shipmentStore,
		pricingService, locationService,
	)
	engine.Run(c.Port)
}
