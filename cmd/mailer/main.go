package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/behouba/akwaba/mailserver"
	postgres "github.com/behouba/akwaba/storage"
	"gopkg.in/yaml.v2"
)

type config struct {
	Port             string             `yaml:"port"`
	DB               *postgres.Config   `yaml:"database"`
	MailServerConfig *mailserver.Config `yaml:"mail"`
	WebsiteURL       string             `yaml:"websiteURL"`
	LogoURL          string             `yaml:"logoURL"`
	TemplatesDir     string             `yaml:"templatesDir"`
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

	handler := mailserver.NewHandler(c.MailServerConfig, c.TemplatesDir, postgres.NewMailingStore(db))

	router := mailserver.NewRouter(handler)

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
