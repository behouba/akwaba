package tracking

import (
	"context"
	"database/sql"
	"errors"

	"github.com/behouba/akwaba"
)

var (
	errShipmentNotFound = errors.New("Aucun colis trouvé")
)

func (s *statements) trackByShipmentID(ctx context.Context, shipmentID uint64) (t akwaba.Tracking, err error) {
	row := s.selectShipmentByIDStmt.QueryRowContext(ctx, shipmentID)
	return s.getTracking(ctx, row, shipmentID)
}

func (s *statements) trackByOrderID(ctx context.Context, orderID uint64) (t akwaba.Tracking, err error) {
	row := s.selectShipmentByOrderIDStmt.QueryRowContext(ctx, orderID)
	return s.getTracking(ctx, row, t.Shipment.ID)
}

// getTracking
func (s *statements) getTracking(
	ctx context.Context, row *sql.Row, shipmentID uint64,
) (t akwaba.Tracking, err error) {
	err = row.Scan(
		&t.Shipment.ID, &t.Shipment.OrderID, &t.Shipment.UserID,
		&t.Shipment.Sender.Name, &t.Shipment.Sender.Phone,
		&t.Shipment.Sender.Area.ID, &t.Shipment.Sender.Area.Name,
		&t.Shipment.Sender.Address, &t.Shipment.Recipient.Name,
		&t.Shipment.Recipient.Phone, &t.Shipment.Recipient.Area.ID,
		&t.Shipment.Recipient.Area.Name, &t.Shipment.Recipient.Address,
		&t.Shipment.TimeCreated, &t.Shipment.Category.ID, &t.Shipment.Category.Name,
		&t.Shipment.Cost, &t.Shipment.State.ID, &t.Shipment.State.Name,
		&t.Shipment.Weight, &t.Shipment.PaymentOption.ID, &t.Shipment.PaymentOption.Name,
		&t.Shipment.Distance, &t.Shipment.Nature,
	)
	if err != nil {
		if err == sql.ErrNoRows {
			err = errShipmentNotFound
		}
		return
	}

	rows, err := s.selectShipmentTrackingStmt.QueryContext(ctx, t.Shipment.ID)
	if err != nil {
		return
	}

	for rows.Next() {
		var e akwaba.Event
		err = rows.Scan(&e.Title, &e.Time, &e.City, &e.Area)
		if err != nil {
			return
		}
		t.Events = append(t.Events, e)
	}
	return
}
