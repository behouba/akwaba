package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"database/sql"

	"github.com/behouba/dsapi/adminapi/internal/jwt"
	"github.com/behouba/dsapi/adminapi/internal/notifier"
	"github.com/behouba/dsapi/adminapi/internal/postgres"
	"github.com/behouba/dsapi/store"
	"github.com/gin-gonic/gin"
)

const (
	version       = "/v0"
	authBaseURL   = "/auth"
	orderBaseURL  = "/order"
	parcelBaseURL = "/parcel"
	userBaseURL   = "/user"
)

// Handler represents the API handler methods set
type Handler struct {
	Db   *postgres.AdminDB
	Auth *jwt.Authenticator
	Sms  *notifier.SMS
}

// SetupRouter create routes and return *gin.Engine
func SetupRouter(a *AuthHandler, o *OrderHandler, u *UserHandler) *gin.Engine {
	r := gin.Default()

	v := r.Group(version)
	{
		auth := v.Group(authBaseURL)
		{
			// authentication routes
			auth.POST("/login", a.login)
			// auth.GET("/logout", h.logout)
		}

		// order := v.Group(orderBaseURL)
		// {
		// 	order.POST("/create", o.createOrder)
		// 	order.GET("/pending", o.pendingOrders)
		// 	order.GET("/info/:orderId", o.orderInfo)
		// 	order.GET("/receipt/:orderId", o.orderReceipt)
		// 	order.PATCH("/cancel/:orderId", o.cancelOrder)
		// 	order.PATCH("/confirm/:orderId", o.confirmOrder)
		// }

		// parcel := v.Group(parcelBaseURL)
		{
			// parcel.POST("/pickup", h.recordPickUp)
			// parcel.POST("/check/in", h.recoredCheckIn)
			// parcel.POST("/check/out", h.recordCheckOut)
			// parcel.POST("/delivery", h.recordDelivery)
			// parcel.GET("/track/:id", h.trackParcel)
		}

		cust := v.Group(userBaseURL)
		{
			cust.POST("/customer", u.createNewCustomer)
			cust.GET("/customer", u.createNewCustomer) // query customerId= , phone=
			cust.PATCH("/freeze/:id", u.freezeCustomer)
			cust.PATCH("/unfreeze/:id", u.unfreezeCustomer)

			address := cust.Group("/address")
			{
				address.GET("/delivery")
				address.POST("/delivery")
				address.GET("/pickup")
				address.POST("/pickup")
			}
		}

	}
	return r
}

// NewDBConn return new pointer to sql.DB
func NewDBConn(dc store.DBConfig) *sql.DB {
	return postgres.Open(dc.Port, dc.Host, dc.User, dc.Password, dc.DB)
}
