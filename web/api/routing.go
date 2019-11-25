package api

import (
	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

const (
	apiPath     = "/api"
	version     = "/v0"
	authPath    = "/auth"
	orderPath   = "/order"
	profilePah  = "/profile"
	pricingPath = "/pricing"
)

// handler represents the website  handlers methods set
type handler struct {
	authenticator   akwaba.TokenService
	locationService akwaba.LocationService
	pricingService  akwaba.PricingService
	accountStore    akwaba.AccountStore
	orderStore      akwaba.OrderStore
	tracker         akwaba.Tracker
}

// SetupAPIEngine set up api routes on *gin.Engine provided
func SetupAPIEngine(
	e *gin.Engine, authenticator akwaba.TokenService,
	locationService akwaba.LocationService, pricingService akwaba.PricingService,
	accountStore akwaba.AccountStore, orderStore akwaba.OrderStore, tracker akwaba.Tracker,
) (err error) {

	r, err := newHandler(
		authenticator, locationService, pricingService,
		accountStore, orderStore, tracker,
	)
	if err != nil {
		return
	}

	api := e.Group(apiPath)
	{
		v := api.Group(version)
		{

			auth := v.Group(authPath)
			auth.GET("/check", r.jwtAuthRequired)

			auth.Use(r.nonJWTAuthenticated)
			{
				auth.POST("/login", r.handleLogin)
				auth.POST("/registration", r.handleRegistration)
				auth.POST("/recovery", r.handleRecovery)
				auth.POST("/change-password", r.handleChangePassword)
			}

			order := v.Group(orderPath)
			order.Use(r.jwtAuthRequired)
			{
				order.POST("/create", r.handleOrderCreation)
				order.PATCH("/cancel/:orderId", r.cancelOrder)
			}

			profile := v.Group(profilePah)
			profile.Use(r.jwtAuthRequired)
			{
				profile.GET("/data", r.profileData)
				profile.GET("/orders", r.orders)
				profile.POST("/update", r.updateProfile)
				profile.POST("/update-password", r.updatePassword)
			}

			v.GET("/pricing", r.computePrice)
			v.GET("/areas", r.areas)
			v.GET("/tracking", r.trackShipment)
			v.GET("/offices", r.offices)
		}
	}
	return
}

// newHandler make new api's handler
func newHandler(
	authenticator akwaba.TokenService, locationService akwaba.LocationService,
	pricingService akwaba.PricingService, accountStore akwaba.AccountStore,
	orderStore akwaba.OrderStore, tracker akwaba.Tracker,
) (*handler, error) {
	return &handler{
		authenticator:   authenticator,
		locationService: locationService,
		accountStore:    accountStore,
		pricingService:  pricingService,
		orderStore:      orderStore,
		tracker:         tracker,
	}, nil
}
