package postgres

import (
	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

type UserStorage struct {
	db *sqlx.DB
}

func NewUserStorage(db *sqlx.DB) *UserStorage {
	return &UserStorage{db: db}
}

func (a *UserStorage) Users() (users []akwaba.User) {
	rows, err := a.db.Query(
		`SELECT 
		user_id, first_name, last_name, phone, email, 
		password, account_type_id, is_email_verified, 
		is_phone_verified 
		FROM users LIMIT 500`,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var c akwaba.User
		err = rows.Scan(
			&c.ID, &c.FirstName, &c.LastName, &c.Phone, &c.Email, &c.Password,
			&c.AccountTypeID, &c.IsEmailVerified,
			&c.IsPhoneVerified,
		)
		if err != nil {
			return
		}
		users = append(users, c)
	}
	return
}

// type OrderStateStore struct {
// 	db *sqlx.DB
// }

// func NewOrderStateStore(db *sqlx.DB) *OrderStateStore {
// 	return &OrderStateStore{db: db}
// }

// func (o *OrderStateStore) UpdateState(ID uint64, stateID uint8) (err error) {

// 	return
// }

type ShipmentStateStore struct {
	db *sqlx.DB
}

func NewShipmentStateStore(db *sqlx.DB) *ShipmentStateStore {
	return &ShipmentStateStore{db: db}
}

func (s *ShipmentStateStore) UpdateState(shipmentID uint64, stateID uint8, areaID uint) (err error) {
	_, err = s.db.Exec(
		`UPDATE shipments SET shipment_state_id=$1 WHERE shipment_id=$2`,
		stateID, shipmentID,
	)
	if err != nil {
		return
	}
	_, err = s.db.Exec(
		`INSERT INTO shipments_history 
		(shipment_id, shipment_state_id, area_id) 
		VALUES ($1, $2, $3)`,
		shipmentID, stateID, areaID,
	)
	if err != nil {
		return
	}
	return
}
