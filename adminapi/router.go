package adminapi

import (
	"github.com/behouba/dsapi/platform/jwt"
	"github.com/behouba/dsapi/platform/notifier"
	"github.com/behouba/dsapi/platform/postgres"
	"github.com/behouba/dsapi/platform/redis"
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
	Db    *postgres.UserDB
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
			order.POST("/news", h.pendingOrders)
			order.PUT("/:id", h.orderInfo)
			order.GET("/confirm/:id", h.confirmOrder)
			order.GET("/cancel/:id", h.cancelOrder)
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
