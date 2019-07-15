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

func main() {
	var config website.Config
	bs, err := ioutil.ReadFile("/Users/a1/Documents/code/akwaba/website/dev-config.yml")
	if err != nil {
		log.Fatal(err)
	}
	err = yaml.Unmarshal(bs, &config)
	if err != nil {
		log.Fatal(err)
	}
	// gin.SetMode(gin.ReleaseMode)

	db, err := postgres.Open(config.DB)
	if err != nil {
		log.Fatal(err)
	}

	handler := website.NewHandler(
		postgres.NewAuthenticator(db), postgres.NewCustomerStore(db), mail.NewCustomerMail(config.Mail),
		postgres.NewPricingStorage(db, config.MapAPIKey), postgres.NewOrderStore(db, config.MapAPIKey), postgres.CitiesMap(),
		postgres.PaymentOptionsMap(), postgres.ShipmentCategoriesMap(),
	)

	router := website.NewRouter(handler)

	s := &http.Server{
		Addr:           getPort(),
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

func getPort() (port string) {
	if len(os.Args) == 1 {
		return ":8081"
	}
	env := os.Args[1]
	if env == "prod" {
		return ":80"
	}
	return ":8080"
}
