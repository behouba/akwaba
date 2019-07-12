package adminapi

import (
	"github.com/behouba/akwaba/postgres"
)

// Config hold configuration data for the adminapi
type Config struct {
	DB         *postgres.Config `yaml:"database"`
	HSecretKey string           `yaml:"hSecretKey"`
	OSecretKey string           `yaml:"oSecretKey"`
	// Mail      *mail.Config     `yaml:"mail"`
	// MapAPIKey string           `yaml:"mapApiKey"`
}
