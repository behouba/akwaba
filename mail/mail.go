package mail

// Config struct encapusulate mailer configuration data
type Config struct {
	SMTP     string `yaml:"smtp"`
	Email    string `yaml:"email"`
	Password string `yaml:"password"`
	Port     int    `yaml:"port"`
}
