package jwt

import (
	"errors"
	"time"

	"github.com/behouba/dsapi"
	"github.com/dgrijalva/jwt-go"
)

var adminTokenDuration = time.Now().Add(1 * time.Minute)

// AdminAuthenticator provide methods to use json web token for admin employees
type AdminAuthenticator struct {
	claims    *adminClaims
	secretKey []byte
}

type adminClaims struct {
	dsapi.Employee
	jwt.StandardClaims
}

// NewAdminAuth return new jwt AdminAuthenticator
func NewAdminAuth(secretKey string) *AdminAuthenticator {
	return &AdminAuthenticator{
		secretKey: []byte(secretKey),
	}
}

// NewJWT take employee struct and create new jwt and return jwt string
func (a *AdminAuthenticator) NewJWT(emp dsapi.Employee) (token string, err error) {
	a.claims = &adminClaims{
		Employee: emp,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: adminTokenDuration.Unix(),
		},
	}
	tk := jwt.NewWithClaims(jwt.SigningMethodHS256, a.claims)

	token, err = tk.SignedString(a.secretKey)

	if err != nil {
		return
	}
	return
}

// ValidateJWT validate passed  jwt token
func (a *AdminAuthenticator) ValidateJWT(token string) (emp dsapi.Employee, err error) {
	tkn, err := jwt.ParseWithClaims(token, a.claims, func(t *jwt.Token) (interface{}, error) {
		return a.secretKey, nil
	})
	if err != nil {
		return
	}

	if !tkn.Valid {
		err = errors.New("Invalid token")
		return
	}
	emp = a.claims.Employee
	return
}
