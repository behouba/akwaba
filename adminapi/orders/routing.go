package orders

import (
	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

const (
	headOfficeBaseURL = "/head-office"
	authBaseURL       = "/auth"
	ordersBaseURL     = "/orders"
	userBaseURL       = "/user"
)

type handler struct {
	auth            akwaba.AdminTokenService
	employeeStore   akwaba.AdminAuthentifier
	orderStore      akwaba.OrderManager
	userStore       akwaba.UserPicker
	shipmentState   akwaba.StateUpdater
	pricingService  akwaba.PricingService
	locationService akwaba.LocationService
}

func SetupOrdersAPIEngine(
	r *gin.RouterGroup, auth akwaba.AdminTokenService,
	orderStore akwaba.OrderManager,
	employeeStore akwaba.AdminAuthentifier,
	userStore akwaba.UserPicker,
	shipmentState akwaba.StateUpdater,
	pricingService akwaba.PricingService,
	locationService akwaba.LocationService,
) {

	h := handler{
		auth, employeeStore, orderStore, userStore,
		shipmentState, pricingService, locationService,
	}
	// head office api for orders management
	head := r.Group(headOfficeBaseURL)
	{
		// head.GET("/tracking", g.trackOrder)
		// head.GET("/system_data", g.systemData)
		auth := head.Group(authBaseURL)
		{
			auth.GET("/check", h.AuthMiddleware())
			auth.POST("/login", h.Login)
		}
		order := head.Group(ordersBaseURL)
		order.Use(h.AuthMiddleware())
		{
			order.GET("/live", h.ActiveOrders)
			order.GET("/closed", h.ClosedOrders)
			order.PATCH("/confirm/:id", h.ConfirmOrder)
			order.PATCH("/cancel/:id", h.CancelOrder)
			order.POST("/create", h.CreateOrder)

		}
		user := head.Group(userBaseURL)
		user.Use(h.AuthMiddleware())
		{
			user.GET("/users", h.Users)
		}
	}
}
