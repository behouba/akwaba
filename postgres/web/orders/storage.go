package orders

import (
	"context"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// Storage represent users account data storage
type Storage struct {
	stmts statements
}

// New create new order storage, return error if it fail
func New(db *sqlx.DB) (*Storage, error) {
	stmts := statements{}
	if err := stmts.prepare(db); err != nil {
		return nil, err
	}

	return &Storage{stmts}, nil
}

// Orders retreive user's orders from database from the given offset
func (s *Storage) Orders(
	ctx context.Context, userID uint, offset uint64,
) ([]akwaba.Order, error) {
	return s.stmts.getUserOrders(ctx, userID, offset)
}

// Order retreive single order of the given user
func (s *Storage) Order(
	ctx context.Context, orderID uint64, userID uint,
) (akwaba.Order, error) {
	return s.stmts.getUserOrder(ctx, orderID, userID)
}

// SaveOrder store new order into database
func (s *Storage) SaveOrder(ctx context.Context, o *akwaba.Order) (err error) {
	return s.stmts.saveOrder(ctx, o)
}

// CancelOrder update order state as canceled order in database
func (s *Storage) CancelOrder(ctx context.Context, id uint64) (err error) {
	return s.stmts.cancelOrder(ctx, id)
}
