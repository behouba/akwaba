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
			public.POST("/compute", h.computeOrderCost)
			public.GET("/tracking/:id", h.trackOrder)
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
