package main

import (
	"io/ioutil"
	"log"
	"os"

	"github.com/behouba/akwaba/adminapi"
	"github.com/behouba/akwaba/adminapi/head"
	"github.com/behouba/akwaba/adminapi/office"
	"github.com/behouba/akwaba/jwt"
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
	headHandler := head.NewHandler(
		jwt.NewAdminAuthenticator(c.HSecretKey),
		postgres.NewOrdersManagementStore(db, c.MapAPIKey),
		postgres.NewHeadManagerStorage(db),
		postgres.NewUserStorage(db),
	)

	officesHandler := office.NewHandler(
		jwt.NewAdminAuthenticator(c.OSecretKey),
		postgres.NewOfficeEmployeeStorage(db),
		postgres.NewShipmentStorage(db),
	)
	if err != nil {
		log.Fatal(err)
	}
	globalHandler := adminapi.NewHandler(
		postgres.NewTrackingStore(db),
		postgres.NewSystemData(),
	)
	if err != nil {
		log.Fatal(err)
	}
	r := adminapi.NewRouter(headHandler, officesHandler, globalHandler)
	r.Run(c.Port)
}
