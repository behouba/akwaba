package akwaba

type AdminTokenService interface {
	NewToken(emp *Employee) (token string, err error)
	Authenticate(token string) (emp Employee, err error)
}

type UserTokenService interface {
	NewToken(u *User) (token string, err error)
	Authenticate(token string) (u User, err error)
}
