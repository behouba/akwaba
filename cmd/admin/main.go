package main

import (
	"fmt"
	"io/ioutil"
	"log"

	"github.com/behouba/akwaba/adminapi"
	"github.com/behouba/akwaba/adminapi/headoffice"
	"github.com/behouba/akwaba/adminapi/office"
	"github.com/behouba/akwaba/jwt"
	"github.com/behouba/akwaba/postgres"
	"gopkg.in/yaml.v2"
)

func main() {
	var config adminapi.Config
	bs, err := ioutil.ReadFile("/Users/a1/Documents/code/akwaba/adminapi/dev-config.yml")
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
		postgres.NewAdminOrderStorage(db, config.MapAPIKey),
		postgres.NewEmployeeStorageH(db),
		postgres.NewAdminCustomerStorage(db),
	)

	officesHandler := office.NewHandler(
		jwt.NewAdminAuthenticator(config.OSecretKey), nil,
		postgres.NewEmployeeStorageO(db),
	)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
	r := adminapi.NewRouter(headHandler, officesHandler)
	r.Run(":8084")
}
