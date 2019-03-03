package router

import (
	"github.com/behouba/dsapi/cmd/userd/router/handler"
	"github.com/gin-gonic/gin"
)

const (
	guestBaseURL    = "/v0/guest"
	customerBaseURL = "/v0/customer"
)

// Setup create routes and return *gin.Engine
func Setup(u *handler.User) *gin.Engine {
	r := gin.Default()

	r.GET("/auth_state", u.CheckAuthState)
	guest := r.Group(guestBaseURL)
	{
		// guest authentication routes

		// first guest auth step
		guest.GET("/phone/check/:phone", u.CheckPhone)
		// 2nd step is phone number match any registred customer
		guest.GET("/phone/confirm/:phone", u.ConfirmPhone)
		// 2nd step for new customer before doing to 2nd step for registered customer
		guest.POST("/registration", u.Registration)
	}
	// customer routes group
	cust := r.Group(customerBaseURL)
	{
		// Logout handler not yet implemented on server side
		// for now client must only delete his own access token
		// plan to implement blacklist of deleted access token
		// on redis in order to keep track of all deleted token.
		cust.POST("/logout", customerLogout)

		// customer orders routes
		cust.POST("/create", createNewOrder)
		cust.POST("/compute", computePrice)
		cust.POST("/cancel/:id", cancelOrder)
		cust.GET("/tracking/:id", trackOrder)
		cust.GET("/orders", trackOrder)

		// cust support routes
		cust.POST("/support", sendMsgToSupport)
		cust.GET("/support/send_msg", fetchSupportMsg)
	}

	return r
}
