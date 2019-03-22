package dsapi

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
	GetUserByPhone(phone string) ([]User, error)
	GetUserByName(name string) ([]User, error)
	GetAddresses(userID int, addrType string) ([]Address, error)
	SaveAddress(addr *Address) (int, error)
	SaveUser(user *User) (int, error)
	// SaveDeliveryAddress(userID int, address *Address) (int, error)
	// SavePickUpAddress(userID int, address *Address) (int, error)
	FreezeUser(userID int) error
	UnFreezeUser(userID int) error
}

// AdminAuthenticator interface for admin login operations
type AdminAuthenticator interface {
	Check(a *AdminCredential) (Employee, error)
}

// Employee represent an employee with it identifiers
type Employee struct {
	ID         int    `json:"id"`
	OfficeID   int    `json:"officeId"`
	PositionID int    `json:"positionId"`
	FullName   string `json:"fullName"`
}

// AdminCredential represent employee authentication data
type AdminCredential struct {
	ID       int    `json:"id, omitempty"`
	Name     string `json:"name" binding:"required"`
	Password string `json:"password" binding:"required"`
}
