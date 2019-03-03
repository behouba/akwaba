package router

import (
	"github.com/gin-gonic/gin"
)

const adminBaseURL = "/v0/admin"

func Setup() *gin.Engine {

	r := gin.Default()
	// admin employee routes group for management tasks
	admin := r.Group(adminBaseURL)
	{
		// employee authentication routes
		admin.GET("/login", dumbHandler)
		admin.GET("/logout", dumbHandler)

		// employee order's management routes
		admin.GET("/orders", dumbHandler)
		admin.GET("/order/:id", dumbHandler)
		admin.POST("/confirm/:id", dumbHandler)
		admin.POST("/cancel/:id", dumbHandler)
		// collect routes
		admin.POST("/collected/:id", dumbHandler)
		admin.POST("/collect/failed/:id", dumbHandler)
		admin.GET("/collects", dumbHandler)
		admin.GET("/archive/collects", dumbHandler)
		// delivery routes
		admin.POST("/delivered/:id", dumbHandler)
		admin.POST("/delivery/failed/:id", dumbHandler)
		admin.GET("/deliveries", dumbHandler)
		admin.GET("/archive/deliveries", dumbHandler)
		// support
		admin.GET("/support/:userID", dumbHandler)
		admin.POST("/support/send_msg", dumbHandler)

		// tracking status update route
		admin.POST("/tracking/update/:locationId", dumbHandler)

	}
	return r
}

func dumbHandler(c *gin.Context) {

}
