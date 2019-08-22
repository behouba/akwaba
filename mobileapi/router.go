package mobileapi

import (
	"time"

	"github.com/behouba/akwaba"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

const (
	version    = "/v0"
	authPath   = "/auth"
	orderPath  = "/order"
	profilePah = "/profile"
)

var corsConfig = cors.New(cors.Config{
	AllowOrigins:     []string{"*"},
	AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
	AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Authorization"},
	AllowCredentials: true,
	MaxAge:           12 * time.Hour,
})

// Handler represents the website  handler methods set
type Handler struct {
	jwt        akwaba.UserTokenService
	auth       akwaba.UserAuthentifier
	userStore  akwaba.UserStorage
	pricing    akwaba.PricingService
	orderStore akwaba.OrderService
	tracker    akwaba.Tracker
	sysData    akwaba.SystemData
}

// NewRouter create routes and return *gin.Engine
func NewRouter(h *Handler) *gin.Engine {
	r := gin.Default()
	r.Use(corsConfig)
	v := r.Group(version)
	{

		auth := v.Group(authPath)
		auth.GET("/check", h.authRequired)
		auth.Use(h.nonAuthenticated)
		{

			auth.POST("/login", h.handleLogin)
			auth.POST("/registration", h.handleRegistration)
			auth.POST("/recovery", h.handleRecovery)
			auth.POST("/password_request", h.handleNewPasswordRequest)
		}

		order := v.Group(orderPath)
		order.Use(h.authRequired)
		{
			order.POST("/create", h.handleOrderCreation)
			// order.GET("/info/:id", authRequired, h.orderInfo)
			order.PATCH("/cancel", h.cancelOrder)
		}

		profile := v.Group(profilePah)
		profile.Use(h.authRequired)
		{
			profile.GET("/data", h.profileData)
			profile.GET("/orders", h.orders)
			profile.POST("/update", h.updateProfile)
			profile.POST("/update-password", h.updatePassword)
		}

		v.GET("/pricing", h.computePrice)
		v.GET("/areas", h.getAreas)
		v.GET("/tracking", h.trackShipment)
	}
	// logout implemented by deleting token on client side
	// r.GET("/auth/logout", h.logout)

	return r
}

// NewHandler return new Handler instance with the provided arguments
func NewHandler(
	jwt akwaba.UserTokenService,
	auth akwaba.UserAuthentifier, userStore akwaba.UserStorage,
	pricing akwaba.PricingService, orderStore akwaba.OrderService,
	tracker akwaba.Tracker,
	sysData akwaba.SystemData,
) *Handler {
	return &Handler{
		jwt:        jwt,
		auth:       auth,
		userStore:  userStore,
		pricing:    pricing,
		orderStore: orderStore,
		tracker:    tracker,
		sysData:    sysData,
	}
}
