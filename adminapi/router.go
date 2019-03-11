package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"github.com/behouba/dsapi/adminapi/internal/jwt"
	"github.com/behouba/dsapi/adminapi/internal/notifier"
	"github.com/behouba/dsapi/adminapi/internal/postgres"
	"github.com/behouba/dsapi/adminapi/internal/redis"
	"github.com/gin-gonic/gin"
)

const (
	version         = "/v0"
	authBaseURL     = "/auth"
	orderBaseURL    = "/order"
	collectBaseURL  = "/collect"
	trackBaseURL    = "/track"
	deliveryBaseURL = "/delivery"
	supportBaseURL  = "/support"
)

// Handler represents the API handler methods set
type Handler struct {
	Db    *postgres.AdminDB
	Cache *redis.Cache
	Auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

// SetupRouter create routes and return *gin.Engine
func SetupRouter(h *Handler) *gin.Engine {
	r := gin.Default()

	v := r.Group(version)
	{
		auth := v.Group(authBaseURL)
		{
			// authentication routes
			auth.POST("/login", h.login)
			auth.GET("/logout", h.logout)
		}

		order := v.Group(orderBaseURL)
		{
			order.GET("/news", h.pendingOrders)
			order.GET("/info/:id", h.orderInfo)
			order.POST("/confirm/:id", h.confirmOrder)
			order.GET("/receipt/:id", h.orderReceipt)
			order.POST("/cancel/:id", h.cancelOrder)
		}

		collect := v.Group(collectBaseURL)
		{
			collect.POST("/done/:orderId", h.collectDone)
			collect.POST("/failed/:orderId", h.collectFailed)
			collect.GET("/collects", h.pendingCollects)
			collect.GET("/archives", h.archivedCollects)
		}

		track := v.Group(trackBaseURL)
		{
			track.POST("/update/:locationID", h.updateOrderLocation)
		}

		delivery := v.Group(deliveryBaseURL)
		{
			delivery.POST("/done/:orderId", h.deliveryDone)
			delivery.POST("/failed/:orderId", h.deliveryFailed)
			delivery.GET("/deliveries", h.pendingDeliveries)
			delivery.GET("/archives", h.archivedDeliveries)
		}

		support := v.Group(supportBaseURL)
		{
			// support support routes
			support.POST("/", h.fetchSupportConv)
			support.GET("/send_msg", h.sendMsgToCustomer)
		}
	}
	return r
}

// AdminHandler build new handler and return it
func AdminHandler(dbConfig string, redisConig string, jwtSecretKey string) *Handler {
	db, err := postgres.Open()
	if err != nil {
		panic(err)
	}

	cache, err := redis.New()
	if err != nil {
		panic(err)
	}

	auth := jwt.NewAdminAuth(jwtSecretKey)

	sms := notifier.NewSMS()

	return &Handler{
		Db:    db,
		Cache: cache,
		Auth:  auth,
		Sms:   sms,
	}
}
