package userapi

import (
	"github.com/gin-gonic/gin"
)

const (
	version        = "/v0"
	authBaseURL    = "/auth"
	orderBaseURL   = "/order"
	publicBaseURL  = "/public"
	supportBaseURL = "/support"
)

// Handler represents the website handler methods set
type Handler struct {
	// Db     *postgres.UserDB
	// Auth   *jwt.Authenticator
	// Sms    *notifier.SMS
	// Mailer *notifier.Mailer
}

// SetupRouter create routes and return *gin.Engine
func SetupRouter(h *Handler) *gin.Engine {
	r := gin.Default()

	return r
}

// NewHandler create take configurations info and return new user handler
func NewHandler(dbConfig string, jwtSecretKey string) *Handler {
	// db, err := postgres.Open(dbConfig)
	// if err != nil {
	// 	log.Println(err)
	// 	panic(err)
	// }

	// auth := jwt.NewAuthenticator([]byte(jwtSecretKey))

	// sms := notifier.NewSMS()
	// mailer := notifier.NewMailer()

	// return &Handler{
	// 	Db:     &db,
	// 	Auth:   auth,
	// 	Sms:    sms,
	// 	Mailer: mailer,
	// }
	return nil
}
