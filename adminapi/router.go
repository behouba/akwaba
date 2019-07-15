package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"time"

	"github.com/behouba/akwaba/adminapi/headoffice"
	"github.com/behouba/akwaba/adminapi/office"
	"github.com/behouba/akwaba/postgres"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

const (
	version           = "/v0"
	headOfficeBaseURL = "/head-office"
	officesBaseURL    = "/offices"
	authBaseURL       = "/auth"
	orderBaseURL      = "/order"
	parcelBaseURL     = "/parcel"
	custBaseURL       = "/customer"
)

var corsConfig = cors.New(cors.Config{
	AllowOrigins:     []string{"http://localhost:8081", "http://localhost:8080"},
	AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
	AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Authorization"},
	AllowCredentials: true,
	MaxAge:           12 * time.Hour,
})

// NewRouter create routes and return *gin.Engine
func NewRouter(h *headoffice.Handler, o *office.Handler) *gin.Engine {
	r := gin.Default()

	r.Use(corsConfig)
	v := r.Group(version)
	v.GET("/pricing", h.ComputePrice)
	{
		// head office api for orders management
		head := v.Group(headOfficeBaseURL)
		{
			head.GET("/system_data", systemData)
			auth := head.Group(authBaseURL)
			{
				auth.GET("/check", h.AuthMiddleware())
				auth.POST("/login", h.Login)
			}
			order := head.Group(orderBaseURL)
			order.Use(h.AuthMiddleware())
			{
				order.GET("/live", h.ActiveOrders)
				order.GET("/closed", h.ClosedOrders)
				order.PATCH("/confirm/:id", h.ConfirmOrder)
				order.PATCH("/cancel/:id", h.CancelOrder)
				order.POST("/create", h.CreateOrder)

			}
			user := head.Group(custBaseURL)
			user.Use(h.AuthMiddleware())
			{
				user.GET("/customers", h.Customers)
			}
		}

		// offices api to manage shipments at localy
		offices := v.Group(officesBaseURL)
		{
			auth := offices.Group(authBaseURL)
			{
				auth.GET("/check", o.AuthMiddleware())
				auth.POST("/login", o.Login)
			}
		}

		// o := v.Group(orderBaseURL)
		// o.Use(h.authMiddleware())
		// {
		// 	o.GET("/pending", h.pendingOrders)
		// 	// o.GET("/to_pick_up", h.ordersToPickUp)
		// 	o.PATCH("/cancel/:id", h.cancelOrder)
		// 	o.PATCH("/confirm/:id", h.confirmOrder)
		// 	o.POST("/create", h.createOrder)
		// }

		// p := v.Group(parcelBaseURL)
		// p.Use(h.authMiddleware())
		// {
		// p.GET("/pick_up", h.parcelsToPickUp)
		// p.PATCH("/collected", h.collected)
		// p.GET("/office_stock", h.officeParcels)
		// p.PATCH("/left_office", h.parcelOut)
		// p.PATCH("/enter_office", h.parcelIn)
		// p.GET("/to_deliver", h.parcelsToDeliver)
		// p.PATCH("/delivered", h.parcelDelivered)
		// p.PATCH("/failed_delivery", h.failedDelivery)
		// p.GET("/track", h.trackOrder)
		// }
		// u := v.Group(custBaseURL)
		// u.Use(h.authMiddleware())
		// {
		// 	u.GET("/contact", h.userContact)
		// 	u.POST("/lock", h.lockContact)
		// 	u.POST("/unlock", h.unlockContact)
		// }
	}
	return r
}

// Config hold configuration data for the adminapi
type Config struct {
	DB         *postgres.Config `yaml:"database"`
	HSecretKey string           `yaml:"hSecretKey"`
	OSecretKey string           `yaml:"oSecretKey"`
	// Mail      *mail.Config     `yaml:"mail"`
	MapAPIKey string `yaml:"mapApiKey"`
}
