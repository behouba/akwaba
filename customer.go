package akwaba

// Customer account type eather regular or professional
const (
	RegularAccountTypeID      uint8 = 1
	ProfessionalAccountTypeID uint8 = 2
)

// Customer of Akwaba Express
type Customer struct {
	ID              uint   `json:"id,omitempty"`
	FullName        string `json:"fullName"`
	Phone           string `json:"phone"`
	Email           string `json:"email"`
	Password        string `json:"password,omitempty"`
	Address         string `json:"address,omitempty"`
	AccessToken     string `json:"access_token,omitempty"`
	AccountTypeID   uint8  `json:"accountTypeId"`
	IsEmailVerified bool   `json:"isEmailVerified"`
	IsPhoneVerified bool   `json:"isPhoneVerified"`
	IsActive        bool   `json:"isActive"`
}

// CustomerAuthentifier define customer authentication interface
type CustomerAuthentifier interface {
	Authenticate(email, password string) (Customer, error)
	SetRecoveryToken(email string) (string, error)
	CheckRecoveryToken(token string) (uint, error)
	UpdatePassword(userID uint, uuid, newPassword string) error
}

type CustomerStorage interface {
	CustomerByEmail(email string) (cust Customer, err error)
	Save(c *Customer) (Customer, error)
	UpdateInfo(newData *Customer) error
}
