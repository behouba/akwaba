package router

import "github.com/gin-gonic/gin"

const (
	customerBaseURL = "v0/customer"
	adminBaseURL    = "v0/admin"
)

// Setup create routes and return *gin.Engine
func Setup() *gin.Engine {
	r := gin.Default()

	// customer routes group
	customer := r.Group(customerBaseURL)
	{
		// customer authentication routes
		customer.POST("/registration", controller)
		customer.POST("/confirm_phone", controller)
		customer.GET("/logout", controller)

		// customer orders routes
		customer.POST("/create", controller)
		customer.POST("/compute", controller)
		customer.POST("/cancel/:id", controller)
		customer.GET("/tracking/:id", controller)
		customer.GET("/orders", controller)

		// customer support routes
		customer.POST("/support", controller)
		customer.GET("/support/send_msg", controller)
	}

	// admin employee routes group for management tasks
	admin := r.Group(adminBaseURL)
	{
		// employee authentication routes
		admin.GET("/login", controller)
		admin.GET("/logout", controller)

		// employee order's management routes
		// admin.GET()
		// admin.GET()
		// admin.POST()
		// admin.POST()
	}
	return r
}

func controller(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "logout",
	})
}
