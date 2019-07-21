package postgres

import (
	"errors"

	"github.com/jmoiron/sqlx"

	"github.com/behouba/akwaba"
)

type TrackingStore struct {
	db *sqlx.DB
}

func NewTrackingStore(db *sqlx.DB) *TrackingStore {
	return &TrackingStore{db: db}
}

func (s *TrackingStore) Track(shipmentID uint64) (t akwaba.Tracking, err error) {
	// retreive shipment info
	err = s.db.QueryRow(
		`SELECT 
		shipment_id, order_id, customer_id, sender_name, sender_phone, sender_area_id,
		sender_area, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_area,
		recipient_address, time_created, shipment_category_id, shipment_category, cost, shipment_state_id,
		shipment_state, weight, payment_option_id, payment_option, distance, nature
	FROM shipments_master 
	WHERE shipment_id=$1;`,
		shipmentID,
	).Scan(
		&t.Shipment.ID, &t.Shipment.OrderID, &t.Shipment.CustomerID,
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
		if err.Error() == "sql: no rows in result set" {
			err = errors.New("Aucun colis trouvé")
		}
		return
	}

	rows, err := s.db.Query(
		`SELECT 
		shipment_state, time_inserted, city, area 
		FROM shipments_tracking WHERE shipment_id=$1 
		ORDER BY time_inserted DESC`,
		shipmentID,
	)
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
