package shipment

import (
	"context"

	"github.com/behouba/akwaba"
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

func (s *Storage) Pickups(
	ctx context.Context, office *akwaba.Office,
) (shipments []akwaba.Shipment, err error) {
	return s.stmts.pickups(ctx, office)
}
func (s *Storage) PickedUp(
	ctx context.Context, office *akwaba.Office, shipmentID uint64, weight float64,
) (err error) {
	return s.stmts.pickedUp(ctx, office, shipmentID, weight)
}
func (s *Storage) UpdateState(
	ctx context.Context, shipmentID uint64, stateID uint8, areaID uint,
) (err error) {
	return s.stmts.updateState(ctx, shipmentID, stateID, areaID)
}
func (s *Storage) Stock(
	ctx context.Context, office *akwaba.Office,
) (shipments []akwaba.Shipment, err error) {
	return s.stmts.stock(ctx, office)
}
func (s *Storage) CheckIn(ctx context.Context, office *akwaba.Office, shipmentID uint64) (err error) {
	return s.stmts.CheckIn(ctx, office, shipmentID)
}
func (s *Storage) CheckOut(ctx context.Context, office *akwaba.Office, shipmentID uint64) (err error) {
	return s.stmts.checkOut(ctx, office, shipmentID)
}
func (s *Storage) Deliveries(
	ctx context.Context, office *akwaba.Office,
) (shipments []akwaba.Shipment, err error) {
	return s.stmts.deliveries(ctx, office)
}
func (s *Storage) Delivered(ctx context.Context, office *akwaba.Office, shipmentID uint64) (err error) {
	return s.stmts.delivered(ctx, office, shipmentID)
}
func (s *Storage) DeliveryFailed(
	ctx context.Context, office *akwaba.Office, shipmentID uint64,
) (err error) {
	return s.stmts.deliveryFailed(ctx, office, shipmentID)
}
