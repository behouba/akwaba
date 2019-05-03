package site

import (
	"log"

	"github.com/behouba/akwaba/user/internal/notifier"
	"github.com/behouba/akwaba/user/internal/postgres"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
)

const (
	templatesPath = "./user/site/templates/*"
	assetsPath    = "./user/site/assets"
)

// Handler represents the website handler methods set
type Handler struct {
	Db *postgres.UserDB
	// Auth   *jwt.Authenticator
	// Sms    *notifier.SMS
	Mailer *notifier.Mailer
}

// SetupRouter create routes and return *gin.Engine
func SetupRouter(h *Handler) *gin.Engine {
	r := gin.Default()
	r.LoadHTMLGlob(templatesPath)
	r.Static("/assets", assetsPath)

	store := cookie.NewStore([]byte("akwaba"))
	r.Use(sessions.Sessions("akwaba-auth", store))

	auth := r.Group("/auth")
	auth.Use(alreadyAuthenticated())
	{
		auth.GET("/login", h.login)
		auth.GET("/registration", h.registration)
		auth.GET("/recovery", h.recovery)
		auth.GET("/new-password-request", h.newPasswordRequest)
		auth.POST("/registration", h.handleRegistration)
		auth.POST("/login", h.handleLogin)
		auth.POST("/recovery", h.handleRecovery)
		auth.POST("/new-password-request", h.handleNewPasswordRequest)
	}
	r.GET("/auth/logout", h.logout)

	r.GET("/", h.home)
	r.GET("/services", h.services)
	r.GET("/order", h.order)
	r.GET("/tracking", h.tracking)
	r.GET("/pricing", h.pricing)
	r.GET("/about", h.about)
	return r
}

// NewHandler create take configurations info and return new user handler
func NewHandler(dbURI string) *Handler {
	db, err := postgres.Open(dbURI)
	if err != nil {
		log.Println(err)
		panic(err)
	}

	// auth := jwt.NewAuthenticator([]byte(jwtSecretKey))

	// sms := notifier.NewSMS()
	mailer := notifier.NewMailer()

	return &Handler{
		Db: &db,
		// Auth:   auth,
		// Sms:    sms,
		Mailer: mailer,
	}
}
