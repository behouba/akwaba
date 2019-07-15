package postgres

import (
	"context"
	"database/sql"
	"errors"
	"log"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
	"googlemaps.github.io/maps"
)

type PricingStorage struct {
	db     *sqlx.DB
	apiKey string
}

func NewPricingStorage(db *sqlx.DB, key string) *PricingStorage {
	return &PricingStorage{db: db, apiKey: key}
}

func (c *PricingStorage) Cost(from, to string, categoryId uint8) (cost uint, distance float64, err error) {
	log.Println(to, from, categoryId)
	var minCost, maxCost float64
	err = c.db.QueryRow(
		"SELECT min_cost, max_cost FROM shipment_categories WHERE shipment_category_id=$1",
		categoryId,
	).Scan(&minCost, &maxCost)
	if err != nil {
		return
	}
	if from == to {
		cost = uint(minCost)
		return
	}
	distance, err = c.distance(from, to)
	if err != nil {
		return
	}
	if distance <= 0 || distance > 100 {
		return 0, 0, errors.New("Cette distance n'est pas supporté par notre système")
	}
	if distance <= 7 {
		cost = uint(minCost)
		return
	}
	cost = uint((distance * maxCost / 100) + minCost)
	return
}

// calculate distance between to place with google place directions api
func (c *PricingStorage) distance(from, to string) (distance float64, err error) {
	client, err := maps.NewClient(maps.WithAPIKey(c.apiKey))
	if err != nil {
		return
	}
	r := &maps.DirectionsRequest{
		Origin:      from,
		Destination: to,
		Language:    "fr",
		Region:      "ci",
	}
	route, _, err := client.Directions(context.Background(), r)
	if err != nil {
		return
	}
	distance = float64(route[0].Legs[0].Distance.Meters) / 1000
	return
}

func (c *PricingStorage) FindArea(query string) (areas []akwaba.Area) {
	var rows *sql.Rows
	var err error

	rows, err = c.db.Query(
		`SELECT area_id, name, city_id FROM areas 
			WHERE name ILIKE $1 || '%' ORDER BY name ASC LIMIT 10`,
		query,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var a akwaba.Area
		err = rows.Scan(&a.ID, &a.Name, &a.CityID)
		if err != nil {
			continue
		}
		areas = append(areas, a)
	}
	if len(areas) < 1 {
		return c.findQueryEveryWhere(query)
	}
	return
}

func (c *PricingStorage) findQueryEveryWhere(query string) (areas []akwaba.Area) {
	var rows *sql.Rows
	var err error

	rows, err = c.db.Query(
		`SELECT area_id, name, city_id FROM areas 
			WHERE name ILIKE '%' || $1 || '%' ORDER BY name ASC LIMIT 10`,
		query,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var a akwaba.Area
		err = rows.Scan(&a.ID, &a.Name, &a.CityID)
		if err != nil {
			continue
		}
		areas = append(areas, a)
	}
	return
}

func roundCost(cost uint) (roundedCost uint) {
	return
}
