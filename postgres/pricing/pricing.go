package pricing

import (
	"context"
	"database/sql"
	"errors"
	"math"

	"github.com/behouba/akwaba"
	"googlemaps.github.io/maps"
)

const (
	missingOriginOrDestinationErr = "L'origine et la destination sont requises"
)

func (s *statements) pricing(
	ctx context.Context, origin, destination, apiKey string,
) (pricing akwaba.Pricing, err error) {

	if origin == "" || destination == "" {
		err = errors.New(missingOriginOrDestinationErr)
		return
	}

	dMinCost, dMaxCost, err := s.minCostMaxCost(ctx, akwaba.DocumentCateogryId)
	if err != nil {
		return
	}
	pMinCost, pMaxCost, err := s.minCostMaxCost(ctx, akwaba.ParcelCategoryId)
	if err != nil {
		return
	}
	if origin == destination {
		pricing.DocumentCost, pricing.ParcelCost = uint(dMinCost), uint(pMinCost)
		return
	}
	pricing.Distance, err = s.distance(origin, destination, apiKey)
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

func (s *statements) computeCost(
	ctx context.Context, categoryID uint8, origin, destination, apiKey string,
) (cost uint, distance float64, err error) {
	minCost, maxCost, err := s.minCostMaxCost(ctx, categoryID)
	if err != nil {
		return
	}
	if origin == "" || destination == "" {
		err = errors.New(missingOriginOrDestinationErr)
		return
	}
	if origin == destination {
		cost = uint(minCost)
		return
	}
	distance, err = s.distance(origin, destination, apiKey)
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

func (s *statements) minCostMaxCost(ctx context.Context, categoryID uint8) (minCost, maxCost float64, err error) {
	err = s.selectMinMaxCostStmt.QueryRowContext(ctx, categoryID).Scan(&minCost, &maxCost)
	if err != nil {
		return
	}
	return
}

// calculate distance between destination place with google place directions api
func (s *statements) distance(origin, destination, apiKey string) (distance float64, err error) {
	client, err := maps.NewClient(maps.WithAPIKey(apiKey))
	if err != nil {
		return
	}
	r := &maps.DirectionsRequest{
		Origin:      origin,
		Destination: destination,
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

func (s *statements) findArea(ctx context.Context, query string) (areas []akwaba.Area) {
	var rows *sql.Rows
	var err error

	rows, err = s.selectAreaStmt.QueryContext(ctx, query)
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
		return s.findQueryEveryWhere(ctx, query)
	}
	return
}

func (s *statements) findQueryEveryWhere(ctx context.Context, query string) (areas []akwaba.Area) {
	var rows *sql.Rows
	var err error

	rows, err = s.selectAreaAlternativeStmt.QueryContext(ctx, query)
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

func (s *statements) selectPaymentOptions() (poMap map[uint8]string, po []akwaba.PaymentOption, err error) {
	poMap = make(akwaba.KeyVal)
	rows, err := s.selectPaymentOptionsStmt.Query()
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.PaymentOption
		err = rows.Scan(&p.ID, &p.Name)
		if err != nil {
			return
		}
		po = append(po, p)
		poMap[p.ID] = p.Name
	}
	return
}

func (s *statements) selectShipmentCategories() (
	catMap map[uint8]string, cats []akwaba.ShipmentCategory, err error,
) {
	catMap = make(map[uint8]string)
	rows, err := s.selectShipmentCategoriesStmt.Query()
	if err != nil {
		return
	}
	for rows.Next() {
		var c akwaba.ShipmentCategory
		err = rows.Scan(&c.ID, &c.Name, &c.MinCost, &c.MaxCost)
		if err != nil {
			return
		}
		cats = append(cats, c)
		catMap[c.ID] = c.Name
	}
	return
}
