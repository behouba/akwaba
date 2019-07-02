package mail

import (
	"github.com/behouba/akwaba"
	"gopkg.in/gomail.v2"
)

const (
	baseURL             = "http://localhost:8080" // "https://www.akwabaexpress.ci"
	copyright           = "Akwaba Express © 2019. Tout droit réservé."
	companyName         = "Akwaba Express"
	resetPasswordSubjet = "Récupération de mot de passe"
	welcomeSubjet       = "Confirmation d'inscription"
	logoURL             = "http://localhost:8080/assets/img/logo_red.png"
)

// CustomerMail implement the CustomerMailer interface
// to provide capability to send email to customer
type CustomerMail struct {
	D      *gomail.Dialer
	Config MailerConfig
}

// NewCustomerMail return new sms objet
func NewCustomerMail(smtp, email, password string, port int) *CustomerMail {
	// d := gomail.NewDialer("mail.spamora.net", 587, "notifications@akwabaexpress.ci", "akwabaexpress")
	d := gomail.NewDialer(smtp, port, email, password)
	return &CustomerMail{
		D: d,
		Config: MailerConfig{
			SMTP:     smtp,
			Email:    email,
			Password: password,
			Port:     port},
	}
}

// newEmailMessage set email headers and return pointer to gomail.Message
func (c *CustomerMail) newEmailMessage(body, subjet, email string) (msg *gomail.Message) {
	msg = gomail.NewMessage()
	msg.SetAddressHeader("From", c.Config.Email, "Akwaba Express")
	msg.SetHeader("To", email)
	msg.SetHeader("Subject", subjet)
	msg.SetBody("text/html", body)
	return
}

// WelcomeEmail send welcome email to new registred customer
func (c CustomerMail) WelcomeEmail(cust *akwaba.Customer) (err error) {
	body, err := c.generateWelcomeHTML(cust.FullName)
	if err != nil {
		return
	}
	msg := c.newEmailMessage(body, welcomeSubjet, cust.Email)
	err = c.D.DialAndSend(msg)
	if err != nil {
		return
	}
	return
}

// ResetPasswordEmail send reset password email to customer
func (c CustomerMail) ResetPasswordEmail(cust *akwaba.Customer, token string) (err error) {
	body, err := c.generateResetPasswordHTML(cust.FullName, token)
	if err != nil {
		return
	}
	msg := c.newEmailMessage(body, resetPasswordSubjet, cust.Email)
	err = c.D.DialAndSend(msg)
	if err != nil {
		return
	}
	return
}

// OrderCreationEmail send email to customer after order has been succesfuly created
func (c CustomerMail) OrderCreationEmail(cust *akwaba.Customer, order *akwaba.Order) (err error) {
	return
}

// OrderConfirmationEmail send email to inform customer that order has been confirmed
func (c CustomerMail) OrderConfirmationEmail(cust *akwaba.Customer, order *akwaba.Order) (err error) {
	return
}

// TrackingStatusEmail send email to inform customer about tracking state update
func (c CustomerMail) TrackingStatusEmail(cust *akwaba.Customer) (err error) {
	return
}
