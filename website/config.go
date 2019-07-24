package website

import (
	"github.com/behouba/akwaba/mail"
	"github.com/behouba/akwaba/postgres"
)

// Config hold configuration data for the website
type Config struct {
	Port      string           `yaml:"port"`
	DB        *postgres.Config `yaml:"database"`
	Mail      *mail.Config     `yaml:"mail"`
	MapAPIKey string           `yaml:"mapApiKey"`
}
