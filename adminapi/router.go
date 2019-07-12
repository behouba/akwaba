package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"time"

	"github.com/behouba/akwaba"

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
	userBaseURL       = "/user"
)

var corsConfig = cors.New(cors.Config{
	AllowOrigins:     []string{"http://localhost:8081", "http://localhost:8080"},
	AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
	AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Authorization"},
	AllowCredentials: true,
	MaxAge:           12 * time.Hour,
})

type HeadOfficeHandler struct {
	auth          akwaba.AdminAuthService
	employeeStore akwaba.EmployeeStore
	orderStore    akwaba.AdminOrderService
}

func NewHeadOfficeHandler(
	auth akwaba.AdminAuthService, orderStore akwaba.AdminOrderService,
	employeeStore akwaba.EmployeeStore,
) *HeadOfficeHandler {
	return &HeadOfficeHandler{
		auth:          auth,
		orderStore:    orderStore,
		employeeStore: employeeStore,
	}
}

type OfficeHandler struct {
	auth          akwaba.AdminAuthService
	employeeStore akwaba.EmployeeStore
	orderStore    akwaba.AdminOrderService
}

func NewOfficeHandler(
	auth akwaba.AdminAuthService, orderStore akwaba.AdminOrderService,
	employeeStore akwaba.EmployeeStore,
) *OfficeHandler {
	return &OfficeHandler{
		auth:          auth,
		orderStore:    orderStore,
		employeeStore: employeeStore,
	}
}

// NewRouter create routes and return *gin.Engine
func NewRouter(h *HeadOfficeHandler, o *OfficeHandler) *gin.Engine {
	r := gin.Default()

	r.Use(corsConfig)
	v := r.Group(version)
	// v.GET("/system_data", h.systemData)
	{
		// head office api for orders management
		head := v.Group(headOfficeBaseURL)
		{
			auth := head.Group(authBaseURL)
			{
				auth.GET("/check", h.authMiddleware())
				auth.POST("/login", h.login)
			}
			order := head.Group(orderBaseURL)
			order.Use(h.authMiddleware())
			{
				order.GET("/pending", h.pendingOrders)
			}
		}

		// offices api to manage shipments at localy
		offices := v.Group(officesBaseURL)
		{
			auth := offices.Group(authBaseURL)
			{
				auth.GET("/check", o.authMiddleware())
				auth.POST("/login", o.login)
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
		// u := v.Group(userBaseURL)
		// u.Use(h.authMiddleware())
		// {
		// 	u.GET("/contact", h.userContact)
		// 	u.POST("/lock", h.lockContact)
		// 	u.POST("/unlock", h.unlockContact)
		// }
	}
	return r
}
