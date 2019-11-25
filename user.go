package akwaba

import "context"

// User account type eather regular or professional
const (
	RegularAccountTypeID      uint8 = 1
	ProfessionalAccountTypeID uint8 = 2
)

// User of Akwaba Express
type User struct {
	ID              uint   `json:"id,omitempty"`
	FirstName       string `json:"firstName"` // prenom
	LastName        string `json:"lastName"`  // nom de famille
	Phone           string `json:"phone"`
	Email           string `json:"email"`
	Password        string `json:"password,omitempty"`
	AccessToken     string `json:"access_token,omitempty"`
	AccountTypeID   uint8  `json:"accountTypeId"`
	IsEmailVerified bool   `json:"isEmailVerified"`
	IsPhoneVerified bool   `json:"isPhoneVerified"`
	IsActive        bool   `json:"isActive"`
}

// AccountStore define user storage interface
type AccountStore interface {
	UserByEmail(ctx context.Context, email string) (user User, err error)
	// UserByID(ctx context.Context, userID string) (user User, err error)
	Save(ctx context.Context, c *User) error
	UpdateUserInfo(ctx context.Context, data *User) error
	UpdatePassword(ctx context.Context, userID uint, current, new string) error
	Authenticate(ctx context.Context, email, password, ip string) (User, error)
	SetRecoveryToken(ctx context.Context, email string) (string, error)
	CheckRecoveryToken(ctx context.Context, token string) (uint, error)
	SaveNewPassword(ctx context.Context, userID uint, uuid, newPassword string) error
}

type OrderStore interface {
	OrderPicker
	OrderSaverCanceler
}

type OrderPicker interface {
	Orders(ctx context.Context, userID uint, offset uint64) (orders []Order, err error)
	Order(ctx context.Context, orderID uint64, userID uint) (order Order, err error)
}

type OrderSaverCanceler interface {
	SaveOrder(ctx context.Context, o *Order) (err error)
	CancelOrder(ctx context.Context, id uint64) (err error)
}
