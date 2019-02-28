package handler

import (
	"github.com/gin-gonic/gin"
)

const (
	guestBaseURL    = "/v0/guest"
	customerBaseURL = "/v0/customer"
	adminBaseURL    = "/v0/admin"
)

// SetupRouter create routes and return *gin.Engine
func SetupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/auth_state", checkAuthState)
	guest := r.Group(guestBaseURL)
	{
		// guest authentication routes

		// first guest auth step
		guest.GET("/phone/check/:phone", checkGuestPhone)
		// 2nd step for already registred customer
		guest.GET("/phone/confirm/:phone", phoneValidation)
		// 2nd step for new customer before doing to 2nd step for registered customer
		guest.POST("/registration", registerGuest)
	}
	// customer routes group
	customer := r.Group(customerBaseURL)
	{
		// logout
		customer.POST("/logout", customerLogout)

		// customer orders routes
		customer.POST("/create", createNewOrder)
		customer.POST("/compute", computePrice)
		customer.POST("/cancel/:id", cancelOrder)
		customer.GET("/tracking/:id", trackOrder)
		customer.GET("/orders", fetchAllOrders)

		// customer support routes
		customer.POST("/support", sendMsgToSupport)
		customer.GET("/support/send_msg", fetchSupportMsg)
	}

	// admin employee routes group for management tasks
	admin := r.Group(adminBaseURL)
	{
		// employee authentication routes
		admin.GET("/login", fetchSupportMsg)
		admin.GET("/logout", fetchSupportMsg)

		// employee order's management routes
		admin.GET("/orders", fetchSupportMsg)
		admin.GET("/order/:id", fetchSupportMsg)
		admin.POST("/confirm/:id", fetchAllOrders)
		admin.POST("/cancel/:id", fetchAllOrders)
		// collect routes
		admin.POST("/collected/:id", fetchAllOrders)
		admin.POST("/collect/failed/:id", fetchAllOrders)
		admin.GET("/collects", fetchAllOrders)
		admin.GET("/archive/collects", fetchAllOrders)
		// delivery routes
		admin.POST("/delivered/:id", fetchAllOrders)
		admin.POST("/delivery/failed/:id", fetchAllOrders)
		admin.GET("/deliveries", fetchAllOrders)
		admin.GET("/archive/deliveries", fetchAllOrders)
		// support
		admin.GET("/support/:userID", fetchAllOrders)
		admin.POST("/support/send_msg", fetchAllOrders)

		// tracking status update route
		admin.POST("/tracking/update/:locationId", fetchAllOrders)

	}
	return r
}
