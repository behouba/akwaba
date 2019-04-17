package jwt

import (
	"errors"
	"log"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
)

// Authenticator provide methods to use json web token for users
type Authenticator struct {
	claims    *Claims
	secretKEY []byte
}

// NewAuthenticator return new jwt authenticator
func NewAuthenticator(secret []byte) *Authenticator {
	return &Authenticator{
		secretKEY: []byte(secret),
	}
}

// Claims is jwt token custom claims
type Claims struct {
	CustID int `json:"custId,omiempty"`
	Phone  int `json:"phone"`
	jwt.StandardClaims
}

// MakeCustomerJWT take customer id create new jwt and return jwt string
func (a *Authenticator) MakeCustomerJWT(customerID int, isMobileApp string) (token string, err error) {

	var userTokenDuration time.Time
	if isMobileApp == "Yes" {
		log.Println("token for mobile application")
		userTokenDuration = time.Now().Add(18000 * time.Hour)
	} else {
		log.Println("token for browser")

		userTokenDuration = time.Now().Add(12 * time.Hour)
	}

	a.claims = &Claims{
		CustID: customerID,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: userTokenDuration.Unix(),
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
func (a *Authenticator) ValidateJWT(tokenString string) (int, error) {
	claims := &Claims{}

	token, err := jwt.ParseWithClaims(tokenString, claims, func(t *jwt.Token) (interface{}, error) {
		return a.secretKEY, nil
	})
	// log.Println("token validity: ", token.Valid)
	if !token.Valid {
		return 0, errors.New("Invalid token")
	}
	if err != nil {
		log.Println(err)
		return 0, err
	}
	return claims.CustID, nil
}
