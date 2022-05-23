package mailstore

import (
	"context"

	"github.com/jmoiron/sqlx"
)

type Storage struct {
	stmts *statements
}

func New(db *sqlx.DB) (*Storage, error) {
	stmts := statements{}

	if err := stmts.prepare(db); err != nil {
		return nil, err
	}
	return &Storage{&stmts}, nil
}

func (s *Storage) FromOrderID(ctx context.Context, orderID uint64) (userName, userEmail string, err error) {
	return s.stmts.selectMailingDataByOrderID(ctx, orderID)
}
func (s *Storage) FromShipmentID(
	ctx context.Context, shipmentID uint64,
) (userName, userEmail string, err error) {
	return s.stmts.selectMailingDataByShipmentID(ctx, shipmentID)
}
func (s *Storage) FromEmail(ctx context.Context, email string) (userName string, err error) {
	return s.stmts.selectUserName(ctx, email)
}
