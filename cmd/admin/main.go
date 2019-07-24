package main

import (
	"io/ioutil"
	"log"
	"os"

	"github.com/behouba/akwaba/adminapi"
	"github.com/behouba/akwaba/adminapi/headoffice"
	"github.com/behouba/akwaba/adminapi/office"
	"github.com/behouba/akwaba/jwt"
	"github.com/behouba/akwaba/postgres"
	"gopkg.in/yaml.v2"
)

var configFile = "prod-config.yml"

func main() {
	var config adminapi.Config

	if len(os.Args) > 1 {
		configFile = os.Args[1]
	}

	bs, err := ioutil.ReadFile(configFile)
	if err != nil {
		log.Fatal(err)
	}
	err = yaml.Unmarshal(bs, &config)
	if err != nil {
		log.Fatal(err)
	}
	db, err := postgres.Open(config.DB)
	if err != nil {
		log.Fatal(err)
	}
	headHandler := headoffice.NewHandler(
		jwt.NewAdminAuthenticator(config.HSecretKey),
		postgres.NewOrdersManagementStore(db, config.MapAPIKey),
		postgres.NewHeadManagerStorage(db),
		postgres.NewCustomerStorage(db),
	)

	officesHandler := office.NewHandler(
		jwt.NewAdminAuthenticator(config.OSecretKey), nil,
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
	r.Run(config.Port)
}
