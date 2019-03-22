package dsapi

import (
	"errors"
	"strconv"
)

// State of customer account in the database
const (
	ActiveUserStateID = 1
	FreezedUserSateID = 2
	BannedUserStateID = 3
)

var (
	errInvalidPhone       = errors.New("le numéro de téléphone fourni est invalide")
	errFullNameIsRequired = errors.New("merci de fournir votre nom complet")
)

// UserOrderer interface for order operation avalaible for users
type UserOrderer interface {
	Save(order *Order) error
	Cancel(userID, orderID int) error
	Track(userID, orderID int) (Order, error)
}

// User is representation of new customer
// registration's data
type User struct {
	ID       int    `json:"id, omitempty"`
	FullName string `json:"fullName" binding:"required"`
	Phone    string `json:"phone" binding:"required"`
	Email    string `json:"email"`
}

// CheckData validate new user information
// before registration
func (u *User) CheckData() (err error) {
	if len(u.Phone) != 8 {
		err = errInvalidPhone
		return
	}
	if _, e := strconv.Atoi(u.Phone); e != nil {
		err = errInvalidPhone
		return
	}
	if u.FullName == "" {
		err = errFullNameIsRequired
		return
	}
	return
}
