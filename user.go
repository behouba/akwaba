package akwaba

import (
	"errors"

	"golang.org/x/crypto/bcrypt"
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
	errShortPassword      = errors.New("Votre mot de passe doit contenir au moins 4 caractères")
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
	ID             int    `json:"id,omitempty"`
	FullName       string `json:"fullName"`
	Phone          string `json:"phone"`
	Email          string `json:"email"`
	Password       string `json:"password,omitempty"`
	HashedPassword string
	City           City   `json:"city"`
	Address        string `json:"address"`
	AccessToken    string `json:"accessToken,omitempty"`
}

// HashPassword hash password provided by user in registration form
func (u *User) HashPassword() (err error) {
	if len(u.Password) < 4 {
		err = errors.New("Mot de passe invalide")
		return
	}
	p, err := bcrypt.GenerateFromPassword([]byte(u.Password), bcrypt.MinCost)
	u.HashedPassword = string(p)
	return
}

// ComparePassword the hashed password and compare it with plain text value.
// return nil if match and error if not
func (u *User) ComparePassword(password string) (err error) {
	return bcrypt.CompareHashAndPassword([]byte(u.HashedPassword), []byte(password))
}

func (u *User) CompareHashWithPassword(hashedPassword string) (err error) {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(u.Password))
}

// validateBeforeRegistration validate new user information
// before registration
func (u *User) validateBeforeRegistration() (err error) {
	if u.FullName == "" {
		err = errFullNameIsRequired
		return
	}

	if len(u.Password) < 4 {
		err = errShortPassword
		return
	}
	return
}
