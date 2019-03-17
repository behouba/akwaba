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
	version       = "/v0"
	authBaseURL   = "/auth"
	orderBaseURL  = "/order"
	parcelBaseURL = "/parcel"
	custBaseURL   = "/customer"
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
			// auth.GET("/logout", h.logout)
		}

		order := v.Group(orderBaseURL)
		{
			order.GET("/pending", h.pendingOrders)
			order.GET("/info/:orderId", h.orderInfo)
			order.GET("/receipt/:orderId", h.orderReceipt)
			order.POST("/create", h.createOrder)
			order.PATCH("/cancel/:orderId", h.cancelOrder)
			order.PATCH("/confirm/:orderId", h.confirmOrder)
		}

		parcel := v.Group(parcelBaseURL)
		{
			parcel.POST("/pickup", h.recordPickUp)
			parcel.POST("/check/in", h.recoredCheckIn)
			parcel.POST("/check/out", h.recordCheckOut)
			parcel.POST("/delivery", h.recordDelivery)
			parcel.GET("/track/:id", h.trackParcel)
		}

		cust := v.Group(custBaseURL)
		{
			cust.POST("/create", h.createNewCustomer)
			cust.GET("/info", h.customerData) // query customerId= , phone=
			cust.PATCH("/freeze/:id", h.freezeCustomer)
			cust.PATCH("/unfreeze/:id", h.unfreezeCustomer)
			// cust.GET("/address/:customerId", h.customerAddress)
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
