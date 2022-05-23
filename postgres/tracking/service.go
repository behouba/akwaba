package tracking

import (
	"context"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// Service represent shipment tracking service
type Service struct {
	stmts *statements
}

// New create new tracking service, return error if it fail
func New(db *sqlx.DB) (*Service, error) {
	stmts := statements{}
	if err := stmts.prepare(db); err != nil {
		return nil, err
	}
	return &Service{&stmts}, nil
}

// TrackShipment return tracking information about given ShipmentID or OrderID
func (s *Service) TrackShipment(ctx context.Context, ID uint64) (tracking akwaba.Tracking, err error) {
	tracking, err = s.stmts.trackByShipmentID(ctx, ID)
	if err != nil {
		return s.stmts.trackByOrderID(ctx, ID)
	}
	return
}
