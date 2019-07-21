package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"time"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/adminapi/headoffice"
	"github.com/behouba/akwaba/adminapi/office"
	"github.com/behouba/akwaba/postgres"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

const (
	version           = "/v0"
	headOfficeBaseURL = "/head-office"
	officeBaseURL     = "/office"
	authBaseURL       = "/auth"
	ordersBaseURL     = "/orders"
	shipmentsBaseURL  = "/shipments"
	custBaseURL       = "/customer"
)

var corsConfig = cors.New(cors.Config{
	AllowOrigins:     []string{"*"},
	AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
	AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Authorization"},
	AllowCredentials: true,
	MaxAge:           12 * time.Hour,
})

// NewRouter create routes and return *gin.Engine
func NewRouter(h *headoffice.Handler, o *office.Handler, g *Handler) *gin.Engine {
	r := gin.Default()

	r.Use(corsConfig)
	v := r.Group(version)
	v.GET("/pricing", h.ComputePrice)
	{
		// head office api for orders management
		head := v.Group(headOfficeBaseURL)
		{
			head.GET("/tracking", g.trackOrder)
			head.GET("/system_data", g.systemData)
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
			user := head.Group(custBaseURL)
			user.Use(h.AuthMiddleware())
			{
				user.GET("/customers", h.Customers)
			}
		}

		// offices api to manage shipments localy
		office := v.Group(officeBaseURL)
		{
			office.GET("/system_data", g.systemData)
			office.GET("/tracking", g.trackOrder)
			auth := office.Group(authBaseURL)
			{
				auth.GET("/check", o.AuthMiddleware())
				auth.POST("/login", o.Login)
			}
			p := office.Group(shipmentsBaseURL)
			p.Use(o.AuthMiddleware())
			{
				p.GET("/pickups", o.PickUps)
				p.GET("/stock", o.Stock)
				p.GET("/deliveries", o.Deliveries)

				p.PATCH("/picked_up", o.PickedUp)
				p.PATCH("/check_in", o.CheckIn)
				p.PATCH("/check_out", o.CheckOut)
				p.PATCH("/delivered", o.Delivered)
				p.PATCH("/failed_delivery", o.FailedDelivery)
			}
		}
	}
	return r
}

type Handler struct {
	tracker akwaba.Tracker
	sysData akwaba.SystemData
}

func NewHandler(tracker akwaba.Tracker, sysData akwaba.SystemData) *Handler {
	return &Handler{
		tracker: tracker,
		sysData: sysData,
	}
}

// Config hold configuration data for the adminapi
type Config struct {
	DB         *postgres.Config `yaml:"database"`
	HSecretKey string           `yaml:"hSecretKey"`
	OSecretKey string           `yaml:"oSecretKey"`
	// Mail      *mail.Config     `yaml:"mail"`
	MapAPIKey string `yaml:"mapApiKey"`
}
