package mail

// MailerConfig struct encapusulate mailer configuration data
type MailerConfig struct {
	SMTP     string
	Email    string
	Password string
	Port     int
}
