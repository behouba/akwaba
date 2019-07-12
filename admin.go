package akwaba

// Positions ids
const (
	HeadOfficeManagerPositionID uint8 = 1
	OfficesManagerPositionID    uint8 = 2
	CourierPositionID           uint8 = 3
)

// AdminParcelManager interface for admin parcel
// type AdminParcelManager interface {
// 	Track(orderID, officeID int) ([]Event, error)
// }

// AdminOrderManager interface for admin orders operation on database
// type AdminOrderManager interface {
// 	Save(order *Order) (int, error)
// 	Confirm(orderID int) error
// 	Cancel(orderID int) error
// 	Get(orderID int) (Order, error)
// 	Pending(officeID int) ([]Order, error)
// }

// AdminUserManager interface for admin to manage customer
// type AdminUserManager interface {
// 	GetUserByPhone(phone string) ([]Customer, error)
// 	GetUserByName(name string) ([]Customer, error)
// 	GetAddresses(userID int, addrType string) ([]Address, error)
// 	SaveAddress(addr *Address) (int, error)
// 	SaveUser(user *Customer) (int, error)
// 	FreezeUser(userID int) error
// 	UnFreezeUser(userID int) error
// }

// AdminAuthenticator interface for admin login operations
// type AdminAuthenticator interface {
// 	NewToken(emp *Employee) (string, error)
// 	AuthenticateToken(token string) (Employee, error)
// }

// Employee represent an employee with it identifiers
type Employee struct {
	ID         uint   `json:"id"`
	FirstName  string `json:"firstName"`
	LastName   string `json:"lastName"`
	Phone      string `json:"phone"`
	Email      string `json:"email"`
	Login      string `json:"login"`
	Password   string `json:"password"`
	Office     Office `json:"office"`
	PositionID uint8  `json:"positionId"`
}

type EmployeeStore interface {
	Authenticate(e *Employee) (empl Employee, err error)
}

type AdminAuthService interface {
	NewToken(emp *Employee) (token string, err error)
	AuthenticateToken(token string) (emp Employee, err error)
}

type AdminOrderService interface {
	Pending() (o []Order, err error)
	Cancel(orderID uint64) (err error)
	Confirm(orderID uint64) (shipmentID uint64, err error)
	Create(o *Order) (err error)
}

// Office represent office data
type Office struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}
