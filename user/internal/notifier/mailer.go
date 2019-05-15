package notifier

import (
	"fmt"
	"log"

	"github.com/behouba/akwaba"
	"gopkg.in/gomail.v2"
)

const baseURL = "http://ec2-35-180-234-11.eu-west-3.compute.amazonaws.com"

func generateEmailVerificationHTML(link, email string) string {
	return fmt.Sprintf(registrationTemplateFormat, link, email)
}

func newPasswordChangeHTML(name, link string) string {
	return fmt.Sprintf(passwordChangeEmail, name, link)
}

// Mailer hold methods set to manage sms action
type Mailer struct {
	D *gomail.Dialer
}

func (m *Mailer) newMail(subjet, link, email, body string) (msg *gomail.Message) {
	msg = gomail.NewMessage()
	msg.SetAddressHeader("From", "notifications@akwabaexpress.ci", "Akwaba Express")
	msg.SetHeader("To", email)
	msg.SetHeader("Subject", subjet)
	msg.SetBody("text/html", body)
	return
}

// NewMailer return new sms objet
func NewMailer() *Mailer {
	d := gomail.NewDialer("mail.spamora.net", 587, "notifications@akwabaexpress.ci", "akwabaexpress")
	return &Mailer{D: d}
}

// SendAuthCode send validation digit code to user
// for authentication and save given code with user id in redis with expiration time
func (m *Mailer) SendAuthCode(email, link string) (code string, err error) {
	code = generateRandomCode()

	err = m.D.DialAndSend(
		m.newMail(
			"Confirmez votre adresse e-mail",
			link, email,
			generateEmailVerificationHTML(link, email),
		),
	)
	if err != nil {
		log.Println(err)
		return
	}
	fmt.Printf("verification email with link %s send to %s \n", link, email)
	return
}

//SendRecoveryMail send password recovery link to user by email
func (m *Mailer) SendRecoveryMail(user *akwaba.User, uuid string) (err error) {
	link := fmt.Sprintf("%s/auth/new-password-request?uuid=%s", baseURL, uuid)
	err = m.D.DialAndSend(
		m.newMail(
			"Récupération de mot de passe",
			link, user.Email,
			newPasswordChangeHTML(user.FullName, link),
		),
	)
	if err != nil {
		log.Println(err)
		return
	}
	fmt.Printf("password change email sent with link %s send to %s \n", link, user.Email)
	return
}
