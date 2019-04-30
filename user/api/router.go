package userapi

import (
	"log"

	"github.com/behouba/akwaba/user/internal/jwt"
	"github.com/behouba/akwaba/user/internal/notifier"
	"github.com/behouba/akwaba/user/internal/postgres"
	"github.com/gin-gonic/gin"
)

const (
	version        = "/v0"
	authBaseURL    = "/auth"
	orderBaseURL   = "/order"
	publicBaseURL  = "/public"
	supportBaseURL = "/support"
)

// Handler represents the API handler methods set
type Handler struct {
	Db     *postgres.UserDB
	Auth   *jwt.Authenticator
	Sms    *notifier.SMS
	Mailer *notifier.Mailer
}

// SetupRouter create routes and return *gin.Engine
func SetupRouter(h *Handler) *gin.Engine {
	r := gin.Default()

	v := r.Group(version)
	{
		// v.GET("/auth_state", h.checkAuthState)

		// Logout handler not yet implemented on server side
		// for now client must only delete his own access token
		// plan to implement blacklist of deleted access token
		// on redis in order to keep track of all deleted token.
		v.POST("/logout", h.createOrder)

		auth := v.Group(authBaseURL)
		{
			// authentication routes
			auth.GET("/phone/check/:phone", h.checkPhone)
			auth.GET("/phone/confirm/:phone", h.confirmPhone)
			auth.POST("/registration", h.registration)
			auth.POST("/login", h.login)
			auth.GET("/check", h.checkAuthState)
			auth.GET("/logout", h.logout)
		}

		order := v.Group(orderBaseURL)
		order.Use(h.authRequired) // authentication middleware handler
		{
			order.POST("/create", h.createOrder)
			order.PUT("/cancel/:id", h.cancelOrder)
			order.GET("/orders", h.allOrders)
		}

		public := v.Group(publicBaseURL)
		{
			public.GET("/compute", h.computeOrderCost)
			public.GET("/tracking/:id", h.setAuthState, h.trackOrder)
		}

		support := v.Group(supportBaseURL)
		{
			// support support routes
			support.POST("/", h.sendMsgToSupport)
			support.GET("/send_msg", h.fetchSupportConv)
		}
	}
	return r
}

// UserHandler create take configurations info and return new user handler
func UserHandler(dbConfig string, jwtSecretKey string) *Handler {
	db, err := postgres.Open(dbConfig)
	if err != nil {
		log.Println(err)
		panic(err)
	}

	auth := jwt.NewAuthenticator([]byte(jwtSecretKey))

	sms := notifier.NewSMS()
	mailer := notifier.NewMailer()

	return &Handler{
		Db:     &db,
		Auth:   auth,
		Sms:    sms,
		Mailer: mailer,
	}
}