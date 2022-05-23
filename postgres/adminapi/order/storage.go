package order

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

func (s *Storage) ActiveOrders(ctx context.Context) (orders []akwaba.Order, err error) {
	return s.stmts.selectActiveOrders(ctx)
}

func (s *Storage) ClosedOrders(ctx context.Context, date string) (orders []akwaba.Order, err error) {
	return s.stmts.selectClosedOrders(ctx, date)
}

func (s *Storage) SaveOrder(ctx context.Context, o *akwaba.Order) (err error) {
	return s.stmts.saveOrder(ctx, o)
}

// Cancel function take order id and cancel
func (s *Storage) CancelOrder(ctx context.Context, orderID uint64) (err error) {
	return s.stmts.cancelOrder(ctx, orderID)
}

func (s *Storage) ConfirmOrder(ctx context.Context, orderID uint64) (shipmentID uint64, err error) {
	return s.stmts.confirmOrder(ctx, orderID)
}

func (s *Storage) CreateShipment(ctx context.Context, orderID uint64) (shipmentID uint64, err error) {
	return s.stmts.createShipment(ctx, orderID)
}

func (s *Storage) UpdateState(ctx context.Context, orderID uint64, stateID uint8) (err error) {
	return s.stmts.updateState(ctx, orderID, stateID)
}

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
