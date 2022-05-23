package pricing

import (
	"context"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// Service for pricing orperation management
type Service struct {
	// db     *sqlx.DB
	apiKey string
	stmts  statements
}

// New create new Service, return error if it failed
func New(db *sqlx.DB, key string) (*Service, error) {
	stmts := statements{}
	if err := stmts.prepare(db); err != nil {
		return nil, err
	}
	return &Service{key, stmts}, nil
}

// Pricing compute prices for all shipment cateogries of a given origin and destination
func (s *Service) Pricing(
	ctx context.Context, origin, destination string,
) (pricing akwaba.Pricing, err error) {
	return s.stmts.pricing(ctx, origin, destination, s.apiKey)
}

// Cost compute cost of a given origin, destination and category
func (s *Service) Cost(
	ctx context.Context, categoryID uint8, origin, destination string,
) (cost uint, distance float64, err error) {
	return s.stmts.computeCost(ctx, categoryID, origin, destination, s.apiKey)
}

// FindAreas return areas matching the givent query string
func (s *Service) FindAreas(ctx context.Context, query string) (areas []akwaba.Area) {
	return s.stmts.findArea(ctx, query)
}

// PaymentOptions retreive payment options available
// from database in map form, slice of PaymentOptions form
// return error if it fail
func (s *Service) PaymentOptions() (poMap map[uint8]string, po []akwaba.PaymentOption, err error) {
	return s.stmts.selectPaymentOptions()
}

// ShipmentCategories retreive shipment categories available
// from database in map form, slice of ShipmentCategory form
// return error if it fail
func (s *Service) ShipmentCategories() (catMap map[uint8]string, cats []akwaba.ShipmentCategory, err error) {
	return s.stmts.selectShipmentCategories()
}
