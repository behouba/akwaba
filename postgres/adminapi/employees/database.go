package employees

import (
	"context"
	"errors"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// Storage represent employees data store
type Storage struct {
	stmts      *statements
	positionID uint8
}

// New create new employee data store
func New(db *sqlx.DB, positionID uint8) (*Storage, error) {
	stmts := statements{}
	if err := stmts.prepare(db); err != nil {
		return nil, err
	}
	if positionID != akwaba.OrdersManagerPositionID&positionID &&
		positionID != akwaba.ShipmentsManagerPositionID {
		return nil, errors.New("Invalid manager position id")
	}
	return &Storage{&stmts, positionID}, nil
}

// Authenticate authenticate orders manager and shipments manager employee
func (s *Storage) Authenticate(ctx context.Context, emp *akwaba.Employee, ip string) (e akwaba.Employee, err error) {
	s.stmts.authenticateManager(ctx, emp, s.positionID, ip)
	return
}
