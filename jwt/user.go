package jwt

import (
	"errors"
	"time"

	"github.com/behouba/akwaba"
	"github.com/dgrijalva/jwt-go"
)

// UserAuthenticator provide methods to use json web token for users
type UserAuthenticator struct {
	claims    *userClaims
	secretKey []byte
}

type userClaims struct {
	akwaba.User
	jwt.StandardClaims
}

// NewUserAuthenticator return new jwt Authenticator for user
func NewUserAuthenticator(secretKey string) *UserAuthenticator {
	return &UserAuthenticator{
		secretKey: []byte(secretKey),
	}
}

// NewToken take User struct and create new jwt and return jwt string
func (a *UserAuthenticator) NewToken(u *akwaba.User) (token string, err error) {
	var duration = time.Now().Add(time.Hour * 1)

	a.claims = &userClaims{
		User: *u,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: duration.Unix(),
		},
	}
	tk := jwt.NewWithClaims(jwt.SigningMethodHS256, a.claims)

	token, err = tk.SignedString(a.secretKey)
	return
}

// Authenticate validate passed  jwt token
func (a *UserAuthenticator) Authenticate(token string) (u akwaba.User, err error) {

	claims := &userClaims{}

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
	u = claims.User
	return
}
