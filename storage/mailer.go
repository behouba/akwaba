package postgres

import "github.com/jmoiron/sqlx"

type MailingStore struct {
	db *sqlx.DB
}

func NewMailingStore(db *sqlx.DB) *MailingStore {
	return &MailingStore{db: db}
}

func (m *MailingStore) FromOrderID(orderID uint64) (userName, userEmail string, err error) {
	err = m.db.QueryRow(
		`SELECT first_name, email FROM mailing_data_view WHERE order_id=$1`,
		orderID,
	).Scan(&userName, &userEmail)
	if err != nil {
		return
	}
	return
}

func (m *MailingStore) FromShipmentID(shipmentID uint64) (userName, userEmail string, err error) {
	err = m.db.QueryRow(
		`SELECT first_name, email FROM mailing_data_view WHERE shipment_id=$1`,
		shipmentID,
	).Scan(&userName, &userEmail)
	if err != nil {
		return
	}
	return
}

func (m *MailingStore) FromEmail(email string) (userName string, err error) {
	err = m.db.QueryRow(
		`SELECT first_name FROM users WHERE email=$1`,
		email,
	).Scan(&userName)
	if err != nil {
		return
	}
	return
}
