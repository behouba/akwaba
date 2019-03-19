package dsapi

import (
	"time"
)

// AdminOrderer interface for admin orders operation on database
type AdminOrderer interface {
	Save(order *Order) error
	Confirm(orderID int) error
	Cancel(orderID int) error
	Get(orderID int) (Order, error)
	Pending(officeID int) ([]Order, error)
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

// Collect represent a collect session information
type Collect struct {
	Date   time.Time `json:"date"`
	By     Employee  `json:"by"`
	Orders []Order   `json:"orders"`
}
