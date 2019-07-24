package akwaba

type TokenAuthService interface {
	NewToken(emp *Employee) (token string, err error)
	AuthenticateToken(token string) (emp Employee, err error)
}
