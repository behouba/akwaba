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
func SetupRouter(a *AuthHandler, o *OrderHandler, u *UserHandler, p *ParcelHandler) *gin.Engine {
	r := gin.Default()

	v := r.Group(version)
	{
		auth := v.Group(authBaseURL)
		{
			// authentication routes
			auth.POST("/login", a.login)
		}

		user := v.Group(userBaseURL)
		{
			user.POST("/profile", u.createCustomer)
			user.GET("/profile", u.customerData) // queries q and by
			user.PATCH("/freeze/:userId", u.freezeCustomer)
			user.PATCH("/unfreeze/:userId", u.unfreezeCustomer)
			user.GET("/address/:type", u.getAddresses) // query type ("delivery", pickup)
			user.POST("/address", u.createAddress)
		}

		order := v.Group(orderBaseURL)
		{
			order.POST("/create", o.createOrder)
			order.GET("/pending", o.pendingOrders)
			order.GET("/info/:orderId", o.getOrder)
			order.GET("/receipt/:orderId", o.orderReceipt)
			order.PATCH("/cancel/:orderId", o.cancelOrder)
			order.PATCH("/confirm/:orderId", o.confirmOrder)
		}

		parcel := v.Group(parcelBaseURL)
		{
			parcel.POST("/check/in", p.recoredCheckIn)
			parcel.POST("/check/out", p.recordCheckOut)
			parcel.POST("/check/delivered", p.recordDelivery)
			parcel.GET("/scan/:orderId", p.nextEvent)
			parcel.GET("/track/:orderId", p.trackParcel)
		}

	}
	return r
}

// NewDBConn return new pointer to sql.DB
func NewDBConn(dc store.DBConfig) *sql.DB {
	return postgres.Open(dc.Port, dc.Host, dc.User, dc.Password, dc.DB)
}
