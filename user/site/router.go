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
	DB *postgres.UserDB
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
		auth.POST("/login", h.handleLogin)

		auth.GET("/registration", h.registration)
		auth.POST("/registration", h.handleRegistration)

		auth.GET("/recovery", h.recovery)
		auth.POST("/recovery", h.handleRecovery)

		auth.GET("/new-password-request", h.newPasswordRequest)
		auth.POST("/new-password-request", h.handleNewPasswordRequest)
	}

	order := r.Group("/order")
	{
		order.GET("/create", h.order)
		order.POST("/create", h.handleOrderCreation)

		// order.GET("/confirm", h.confirmOrder)
		order.POST("/confirm", h.handleConfirmOrder)
		order.GET("/receipt/:id", h.serveOrderReceipt)
	}

	profile := r.Group("/profile")
	{
		profile.GET("/settings", h.settings)
		profile.GET("/orders", h.orders)

	}

	pricing := r.Group("/pricing")
	{
		pricing.GET("", h.pricing)
		pricing.GET("/compute", h.computePrice)
	}
	r.GET("/auth/logout", h.logout)

	r.GET("/", h.home)
	r.GET("/services", h.services)
	r.GET("/tracking", h.tracking)
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
		DB: &db,
		// Auth:   auth,
		// Sms:    sms,
		Mailer: mailer,
	}
}
