package jwt

import (
	"errors"
	"time"

	"github.com/behouba/akwaba"
	"github.com/dgrijalva/jwt-go"
)

// Authenticator provide methods to use json web token for admin employees
type Authenticator struct {
	claims    *adminClaims
	secretKey []byte
}

// Authenticator provide methods to use json web token for admin employees
// type Authenticator struct {
// 	claims    *claims
// 	secretKey []byte
// }

type adminClaims struct {
	akwaba.Employee
	jwt.StandardClaims
}

// NewAuthenticator return new jwt Authenticator
func NewAuthenticator(secretKey string) *Authenticator {
	return &Authenticator{
		secretKey: []byte(secretKey),
	}
}

// NewToken take employee struct and create new jwt and return jwt string
func (a *Authenticator) NewToken(emp *akwaba.Employee) (token string, err error) {
	var duration = time.Now().Add(time.Hour)

	a.claims = &adminClaims{
		Employee: *emp,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: duration.Unix(),
		},
	}
	tk := jwt.NewWithClaims(jwt.SigningMethodHS256, a.claims)

	token, err = tk.SignedString(a.secretKey)
	return
}

// Authenticate validate passed  jwt token
func (a *Authenticator) Authenticate(token string) (emp akwaba.Employee, err error) {

	claims := &adminClaims{}

	tkn, err := jwt.ParseWithClaims(token, claims, func(t *jwt.Token) (interface{}, error) {
		return a.secretKey, nil
	})
	if err != nil {
		return
	}

	if !tkn.Valid {
		err = errors.New("Invalid token")
		return
	}
	emp = claims.Employee
	return
}
