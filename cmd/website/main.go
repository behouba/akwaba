package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/behouba/akwaba/jwt"
	"github.com/behouba/akwaba/postgres"
	"github.com/behouba/akwaba/website"
	"gopkg.in/yaml.v2"
)

type config struct {
	Port      string           `yaml:"port"`
	DB        *postgres.Config `yaml:"database"`
	SecretKey string           `yaml:"secretKey"`
	MapAPIKey string           `yaml:"mapApiKey"`
}

var configFile = "prod-config.yml"

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
	handler := website.NewHandler(
		jwt.NewUserAuthenticator(c.SecretKey),
		postgres.NewSystemData(),
		postgres.NewAuthenticator(db),
		postgres.NewUserStore(db),
		postgres.NewPricingStorage(db, c.MapAPIKey),
		postgres.NewOrderStore(db, c.MapAPIKey),
		postgres.NewTrackingStore(db),
		postgres.CitiesMap(),
		postgres.PaymentOptionsMap(),
		postgres.ShipmentCategoriesMap(),
	)

	router := website.NewRouter(handler)

	s := &http.Server{
		Addr:           c.Port,
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
