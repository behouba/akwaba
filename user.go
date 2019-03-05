package dsapi

import (
	"errors"
	"strconv"
)

var (
	errInvalidPhone       = errors.New("Le numéro de téléphone fourni est invalid")
	errFullNameIsRequired = errors.New("Merci de fournir votre nom complet")
)

// User is representation of new customer
// registration's data
type User struct {
	FirstName string  `json:"firstName"`
	LastName  string  `json:"lastName"`
	TownID    int     `json:"townId"`
	Phone     string  `json:"phone"`
	Email     string  `json:"email"`
	PostionX  float32 `json:"positionX"`
	PostionY  float32 `json:"positionY"`
}

// CheckNewUserData validate new user information
// before registration
func (u *User) CheckNewUserData() (err error) {
	if len(u.Phone) != 8 {
		err = errInvalidPhone
		return
	}
	if _, e := strconv.Atoi(u.Phone); e != nil {
		err = errInvalidPhone
		return
	}
	if u.FirstName == "" || u.LastName == "" {
		err = errFullNameIsRequired
		return
	}
	return
}
