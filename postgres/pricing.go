package postgres

import (
	"context"
	"database/sql"
	"errors"
	"math"

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

func (c *PricingStorage) Pricing(from, to string) (pricing akwaba.Pricing, err error) {
	dMinCost, dMaxCost, err := c.minCostMaxCost(akwaba.DocumentCateogryId)
	if err != nil {
		return
	}
	pMinCost, pMaxCost, err := c.minCostMaxCost(akwaba.ParcelCategoryId)
	if err != nil {
		return
	}
	if from == to {
		pricing.DocumentCost, pricing.ParcelCost = uint(dMinCost), uint(pMinCost)
		return
	}
	pricing.Distance, err = c.distance(from, to)
	if err != nil {
		return
	}
	if pricing.Distance <= 0 || pricing.Distance > 100 {
		return pricing, errors.New("Cette distance n'est pas supporté par notre système")
	}
	if pricing.Distance <= 7 {
		pricing.DocumentCost, pricing.ParcelCost = uint(dMinCost), uint(pMinCost)
		return
	}
	dRawCost := uint((pricing.Distance * dMaxCost / 100) + dMinCost)
	pRawCost := uint((pricing.Distance * pMaxCost / 100) + pMinCost)
	pricing.DocumentCost, pricing.ParcelCost = roundCost(dRawCost), roundCost(pRawCost)
	return
}

func (c *PricingStorage) Cost(from, to string, categoryId uint8) (cost uint, distance float64, err error) {
	minCost, maxCost, err := c.minCostMaxCost(categoryId)
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
	rawCost := uint((distance * maxCost / 100) + minCost)
	cost = roundCost(rawCost)
	return
}

func (c *PricingStorage) minCostMaxCost(categoryId uint8) (minCost, maxCost float64, err error) {
	err = c.db.QueryRow(
		"SELECT min_cost, max_cost FROM shipment_categories WHERE shipment_category_id=$1",
		categoryId,
	).Scan(&minCost, &maxCost)
	if err != nil {
		return
	}
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
			WHERE name ILIKE $1 || '%' ORDER BY name ASC LIMIT 100`,
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
			WHERE name ILIKE '%' || $1 || '%' ORDER BY name ASC LIMIT 100`,
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

func roundCost(cost uint) uint {
	var unit uint = 50
	if cost%unit == 0 {
		return cost
	}
	if cost%unit > (unit / 2) {
		return unit * uint(math.Ceil(float64(cost/unit)))
	}
	return unit * uint(math.Floor(float64(cost/unit)))
}
