package website

import (
	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
)

const (
	templatesPath = "./templates/*"
	assetsPath    = "./assets"
)

// Handler represents the website  handler methods set
type Handler struct {
	auth               akwaba.CustomerAuthentifier
	customerStore      akwaba.CustomerStorage
	mailer             akwaba.CustomerMailer
	pricing            akwaba.PricingService
	orderStore         akwaba.OrderService
	tracker            akwaba.Tracker
	cities             akwaba.KeyVal
	paymentOptions     akwaba.KeyVal
	shipmentCategories akwaba.KeyVal
}

// NewRouter create routes and return *gin.Engine
func NewRouter(h *Handler) *gin.Engine {
	r := gin.Default()
	r.LoadHTMLGlob(templatesPath)
	r.Static("/assets", assetsPath)
	store := cookie.NewStore([]byte("akwaba"))
	r.Use(sessions.Sessions("akwaba-auth", store))

	gin.SetMode(gin.ReleaseMode)

	auth := r.Group("/auth")
	auth.Use(alreadyAuthenticated)
	{
		auth.GET("/login", h.login)
		auth.POST("/login", h.handleLogin)
		auth.GET("/registration", h.registration)
		auth.POST("/registration", h.handleRegistration)
		auth.GET("/recovery", h.recovery)
		auth.POST("/recovery", h.handleRecovery)
		auth.GET("/new-password-request", h.newPasswordRequest)
		auth.POST("/new-password-request", h.handleNewPasswordRequest)
	}

	order := r.Group("/order")
	{
		order.GET("/pricing", h.orderPricing)
		order.GET("/form", authRequired, h.orderForm)
		order.POST("/create", authRequired, h.handleOrderCreation)
		order.GET("/info/:id", authRequired, h.orderInfo)
		order.GET("/success", authRequired, h.orderSuccess)
	}

	profile := r.Group("/profile")
	profile.Use(authRequired)
	{
		profile.GET("/settings", h.settings)
		profile.GET("/data", h.profileData)
		profile.GET("/orders", h.orders)
		profile.GET("/all-orders", h.ordersJSON)
		profile.POST("/update", h.updateProfile)
	}

	pricing := r.Group("/pricing")
	{
		pricing.GET("/compute", h.computePrice)
	}

	search := r.Group("/search")
	{
		search.GET("/area", h.searchArea)
	}
	shipment := r.Group("/shipment")
	{
		shipment.GET("/tracking", h.trackShipment)
	}

	r.GET("/auth/logout", h.logout)

	r.GET("/", h.home)
	r.GET("/services", h.services)
	r.GET("/tracking", h.tracking)
	r.GET("/about", h.about)
	r.GET("/general-conditions", h.conditions)
	r.GET("/privacy-policy", h.privacyPolicy)

	r.NoRoute(func(c *gin.Context) {
		c.HTML(404, "404", nil)
	})

	return r
}

// NewHandler create take configurations info and return new user handler
// auth               akwaba.CustomerAuthentifier
// 	customerStore      akwaba.CustomerStorage
// 	mailer             akwaba.CustomerMailer
// 	pricing         akwaba.ShipmentCalculator
// 	orderStore         akwaba.OrderService
// 	cities             akwaba.KeyVal
// 	paymentOptions     akwaba.KeyVal
// 	shipmentCategories akwaba.KeyVal
func NewHandler(
	auth akwaba.CustomerAuthentifier, customerStore akwaba.CustomerStorage,
	mailer akwaba.CustomerMailer, pricing akwaba.PricingService, orderStore akwaba.OrderService,
	tracker akwaba.Tracker,
	cities akwaba.KeyVal, paymentOptions akwaba.KeyVal, shipmentCategories akwaba.KeyVal,
) *Handler {
	// db, err := postgres.Open(c.DB)
	// if err != nil {
	// 	log.Println(err)
	// 	panic(err)
	// }

	return &Handler{
		auth:               auth,
		customerStore:      customerStore,
		mailer:             mailer,
		pricing:            pricing,
		orderStore:         orderStore,
		tracker:            tracker,
		cities:             cities,
		paymentOptions:     paymentOptions,
		shipmentCategories: shipmentCategories,
	}
}
