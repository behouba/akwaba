package notifier

import (
	"fmt"
	"github.com/behouba/akwaba"
)

// Mailer hold methods set to manage sms action
type Mailer struct {
}

// NewMailer return new sms objet
func NewMailer() *Mailer {
	return &Mailer{}
}

// SendAuthCode send validation digit code to user
// for authentication and save given code with user id in redis with expiration time
func (m *Mailer) SendAuthCode(user *dsapi.User) (code string, err error) {
	code = generateRandomCode()
	fmt.Printf("code %s sms send to %s  by email \n", code, user.Email)
	return
}
