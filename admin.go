package akwaba

// AdminParcelManager interface for admin parcel
type AdminParcelManager interface {
	Track(orderID, officeID int) ([]Event, error)
}

// AdminOrderManager interface for admin orders operation on database
type AdminOrderManager interface {
	Save(order *Order) (int, error)
	Confirm(orderID int) error
	Cancel(orderID int) error
	Get(orderID int) (Order, error)
	Pending(officeID int) ([]Order, error)
}

// AdminUserManager interface for admin to manage customer
type AdminUserManager interface {
	GetUserByPhone(phone string) ([]Customer, error)
	GetUserByName(name string) ([]Customer, error)
	GetAddresses(userID int, addrType string) ([]Address, error)
	SaveAddress(addr *Address) (int, error)
	SaveUser(user *Customer) (int, error)
	FreezeUser(userID int) error
	UnFreezeUser(userID int) error
}

// AdminAuthenticator interface for admin login operations
type AdminAuthenticator interface {
	NewToken(emp *Employee) (string, error)
	AuthenticateToken(token string) (Employee, error)
}

// Employee represent an employee with it identifiers
type Employee struct {
	ID         uint32 `json:"id",omitempty`
	FullName   string `json:"fullName"`
	Phone      string `json:"phone"`
	Email      string `json:"email"`
	Login      string `json:"login"`
	Password   string `json:"password"`
	Office     Office `json:"office"`
	PositionID uint8  `json:"positionId",omitempty`
}

type Office struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}
