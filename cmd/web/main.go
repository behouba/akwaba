package main

import (
	"io/ioutil"
	"log"
	"os"

	"github.com/behouba/akwaba/storage/tracking"

	"github.com/behouba/akwaba/storage/location"

	"github.com/behouba/akwaba/storage/pricing"

	"github.com/behouba/akwaba/web/storage/orders"

	"github.com/behouba/akwaba/web/storage/accounts"

	postgres "github.com/behouba/akwaba/storage"
	"github.com/behouba/akwaba/web"
	"github.com/behouba/akwaba/web/jwt"
	"gopkg.in/yaml.v2"
)

type config struct {
	Port             string           `yaml:"port"`
	DB               *postgres.Config `yaml:"database"`
	SecretKey        string           `yaml:"secretKey"`
	MapAPIKey        string           `yaml:"mapApiKey"`
	TemplatesPath    string           `yaml:"templatesPath"`
	AssetsPath       string           `yaml:"assetsPath"`
	UsersDatabaseURI string           `yaml:"usersDatabaseURI"`
}

var configFile = "~/.config/prod-config.yml"

func main() {
	var cfg config

	if len(os.Args) > 1 {
		configFile = os.Args[1]
	}

	bs, err := ioutil.ReadFile(configFile)
	if err != nil {
		log.Fatal(err)
	}
	err = yaml.Unmarshal(bs, &cfg)
	if err != nil {
		log.Fatal(err)
	}
	db, err := postgres.Open(cfg.DB)
	if err != nil {
		log.Fatal(err)
	}

	tokenAuthenticator := jwt.NewAuthenticator(cfg.SecretKey)

	pricingService, err := pricing.New(db, cfg.MapAPIKey)
	if err != nil {
		log.Fatal(err)
	}

	locationService, err := location.New(db)
	if err != nil {
		log.Fatal(err)
	}

	trackingService, err := tracking.New(db)
	if err != nil {
		log.Fatal(err)
	}

	accountsStorage, err := accounts.New(db)
	if err != nil {
		log.Fatal(err)
	}

	orderStorage, err := orders.New(db)
	if err != nil {
		log.Fatal(err)
	}

	engine, err := web.Setup(
		tokenAuthenticator, locationService, pricingService,
		accountsStorage, orderStorage, trackingService,
		cfg.TemplatesPath, cfg.AssetsPath,
	)
	if err != nil {
		log.Fatal(err)
	}

	engine.Run(cfg.Port)
}
