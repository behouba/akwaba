package akwaba

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

// UserAuthentifier define user authentication interface
type UserAuthentifier interface {
	Authenticate(email, password, ip string) (User, error)
	SetRecoveryToken(email string) (string, error)
	CheckRecoveryToken(token string) (uint, error)
	UpdatePassword(userID uint, uuid, newPassword string) error
}

// UserStorage define user storage interface
type UserStorage interface {
	UserByEmail(email string) (user User, err error)
	Save(c *User) error
	Update(data *User) error
	UpdatePassword(current, new string, custID uint) error
}
