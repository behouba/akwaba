package jwt

import (
	"errors"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
)

// Authenticator provide methods to use json web token
type Authenticator struct {
	claims    *claims
	secretKEY []byte
}

// NewAuthenticator return new jwt authenticator
func NewAuthenticator(secret []byte) *Authenticator {
	return &Authenticator{
		secretKEY: []byte(secret),
	}
}

type claims struct {
	CustID int `json:"custId,omiempty"`
	Phone  int `json:"phone"`
	jwt.StandardClaims
}

// MakeCustomerJWT take customer id create new jwt and return jwt string
func (a *Authenticator) MakeCustomerJWT(customerID int) (token string, err error) {

	expiration := time.Now().Add(1 * time.Minute)
	a.claims = &claims{
		CustID: customerID,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expiration.Unix(),
		},
	}
	tk := jwt.NewWithClaims(jwt.SigningMethodHS256, a.claims)

	token, err = tk.SignedString(a.secretKEY)

	if err != nil {
		return
	}
	return
}

// ValidateJWT validate passed  jwt token
func (a Authenticator) ValidateJWT(token string) (int, error) {
	tkn, err := jwt.ParseWithClaims(token, a.claims, func(t *jwt.Token) (interface{}, error) {
		return a.secretKEY, nil
	})
	if err != nil {
		return 0, err
	}

	if !tkn.Valid {
		return 0, errors.New("Invalid token")
	}

	return a.claims.CustID, nil
}
