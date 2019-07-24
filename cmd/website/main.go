package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/behouba/akwaba/mail"
	"github.com/behouba/akwaba/postgres"
	"github.com/behouba/akwaba/website"
	"gopkg.in/yaml.v2"
)

var configFile = "prod-config.yml"

func main() {
	var config website.Config

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

	handler := website.NewHandler(
		postgres.NewAuthenticator(db), postgres.NewCustomerStore(db), mail.NewCustomerMail(config.Mail),
		postgres.NewPricingStorage(db, config.MapAPIKey), postgres.NewOrderStore(db, config.MapAPIKey),
		postgres.NewTrackingStore(db), postgres.CitiesMap(),
		postgres.PaymentOptionsMap(), postgres.ShipmentCategoriesMap(),
	)

	router := website.NewRouter(handler)

	s := &http.Server{
		Addr:           config.Port,
		Handler:        router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	err = s.ListenAndServe()
	if err != nil {
		log.Fatal(err)
	}
}
