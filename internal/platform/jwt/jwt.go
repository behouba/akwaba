package jwt

import (
	"errors"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
)

var (
	custSecretKEY = []byte("customer_secret_key")
)

type claims struct {
	CustID int `json:"custId,omiempty"`
	Phone  int `json:"phone"`
	jwt.StandardClaims
}

// MakeCustomerJWT take customer id create new jwt and return jwt string
func MakeCustomerJWT(customerID int) (token string, err error) {

	expiration := time.Now().Add(1 * time.Minute)
	c := &claims{
		CustID: customerID,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expiration.Unix(),
		},
	}
	tk := jwt.NewWithClaims(jwt.SigningMethodHS256, c)

	token, err = tk.SignedString(custSecretKEY)

	if err != nil {
		return
	}
	return
}

// ValidateJWT validate passed  jwt token
func ValidateJWT(token string) (customerID int, err error) {
	c := &claims{}
	tkn, err := jwt.ParseWithClaims(token, c, func(t *jwt.Token) (interface{}, error) {
		return custSecretKEY, nil
	})
	if err != nil {
		return
	}

	if !tkn.Valid {
		return 0, errors.New("Invalid token")
	}
	customerID = c.CustID
	return
}
