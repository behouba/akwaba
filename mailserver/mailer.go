package mailserver

import (
	"html/template"
	"log"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
	"gopkg.in/gomail.v2"
)

const (
	resetPasswordSubjet = "RÉCUPÉRATION DE MOT DE PASSE"
	welcomeSubjet       = "CONFIRMATION D'INSCRIPTION"
	version             = "/v0"
)

// Config struct encapusulate mailer configuration data
type Config struct {
	SMTP     string `yaml:"smtp"`
	Email    string `yaml:"email"`
	Password string `yaml:"password"`
	Port     int    `yaml:"port"`
}

type Handler struct {
	dialer *gomail.Dialer
	config *Config
	templ  *template.Template
	store  akwaba.MailingDataStorage
}

// NewHandler return new handler struct
func NewHandler(c *Config, templatesDir string, store akwaba.MailingDataStorage) *Handler {
	templ, err := template.ParseGlob(templatesDir + "/*")
	if err != nil {
		log.Println(err)
		panic(err)
	}
	log.Println(c)
	d := gomail.NewDialer(c.SMTP, c.Port, c.Email, c.Password)
	return &Handler{
		dialer: d,
		config: c,
		templ:  templ,
		store:  store,
	}
}

func NewRouter(h *Handler) (r *gin.Engine) {
	r = gin.Default()
	v := r.Group(version)
	{
		v.GET("/welcome", h.welcomeEmail)   // user_name and user_email queries are required
		v.GET("/recovery", h.recoveryEmail) // user_email and token queries are required

		o := v.Group("/order")
		{
			o.GET("/creation", h.orderCreationEmail)
			o.GET("/cancelation", h.orderCancelationEmail)
			o.GET("/confirmation", h.orderConfirmationEmail)
		}

		s := v.Group("/shipment")
		{
			// s.GET("/tracking", h.trackingStateChangeEmail)
			s.GET("/delivery", h.deliveryEmail)
			s.GET("/delivery_failure", h.deliveryFailureEmail)
		}
	}

	return
}
