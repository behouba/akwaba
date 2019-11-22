package website

import (
	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
)

const (
	templatesPath = "templates/*"
	assetsPath    = "assets/"
	apiPath       = "/api"
	version       = "/v0"
	authPath      = "/auth"
	orderPath     = "/order"
	profilePah    = "/profile"
	pricingPath   = "/pricing"
)

// Handler represents the website  handler methods set
type Handler struct {
	jwt                akwaba.UserTokenService
	sysData            akwaba.SystemData
	auth               akwaba.UserAuthentifier
	userStore          akwaba.UserStorage
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
	// gin.SetMode(gin.ReleaseMode)

	auth := r.Group(authPath)
	auth.Use(h.alreadyAuthenticated)
	{
		auth.GET("/login", h.loginHTML)
		auth.POST("/login", h.handleLoginForm)
		auth.GET("/registration", h.registrationHTML)
		auth.POST("/registration", h.handleRegistrationForm)
		auth.GET("/recovery", h.recoveryHTML)
		auth.GET("/change-password", h.changePasswordHTML)
	}

	order := r.Group(orderPath)
	{
		order.GET("/pricing", h.orderPricingHTML)
		order.GET("/form", h.authRequired, h.orderForm)
		order.POST("/create", h.authRequired, h.handleOrderCreation)
		order.GET("/success", h.authRequired, h.orderSuccess)
		order.PATCH("/cancel/:orderId", h.authRequired, h.cancelOrder)
	}

	profile := r.Group(profilePah)
	profile.Use(h.authRequired)
	{
		profile.GET("/settings", h.settingsHTML)
		profile.GET("/data", h.profileData)
		profile.GET("/my_orders", h.userOrdersHTML)
		profile.GET("/orders", h.orders)
		profile.POST("/update", h.updateProfile)
		profile.POST("/update-password", h.updatePassword)
		profile.GET("/update-password", h.updatePasswordHTML)
	}

	r.GET("/auth/logout", h.logout)

	r.GET("/", h.homeHTML)
	r.GET("/services", h.servicesHTML)
	r.GET("/tracking", h.trackingHTML)
	r.GET("/about", h.aboutHTML)
	r.GET("/general-conditions", h.conditionsHTML)
	r.GET("/privacy-policy", h.privacyPolicyHTML)

	// API Handlers, plan to make this api only server to serve spa and mobile app
	api := r.Group(apiPath)
	{
		v := api.Group(version)
		{

			auth := v.Group(authPath)
			auth.GET("/check", h.jwtAuthRequired)

			auth.Use(h.nonJWTAuthenticated)
			{
				auth.POST("/login", h.handleLogin)
				auth.POST("/registration", h.handleRegistration)
				auth.POST("/recovery", h.handleRecovery)
				auth.POST("/change-password", h.alreadyAuthenticated, h.handleChangePassword)
			}

			order := v.Group(orderPath)
			order.Use(h.jwtAuthRequired)
			{
				order.POST("/create", h.handleOrderCreation)
				order.PATCH("/cancel", h.cancelOrder)
			}

			profile := v.Group(profilePah)
			profile.Use(h.jwtAuthRequired)
			{
				profile.GET("/data", h.profileData)
				profile.GET("/orders", h.orders)
				profile.POST("/update", h.updateProfile)
				profile.POST("/update-password", h.updatePassword)
			}

			v.GET("/pricing", h.computePrice)
			v.GET("/areas", h.areas)
			v.GET("/tracking", h.trackShipment)
			v.GET("/offices", h.offices)
		}
	}

	r.NoRoute(func(c *gin.Context) {
		c.HTML(404, "404", nil)
	})
	return r
}

func NewHandler(
	jwt akwaba.UserTokenService,
	sysData akwaba.SystemData,
	auth akwaba.UserAuthentifier, userStore akwaba.UserStorage,
	pricing akwaba.PricingService, orderStore akwaba.OrderService,
	tracker akwaba.Tracker,
	cities akwaba.KeyVal, paymentOptions akwaba.KeyVal, shipmentCategories akwaba.KeyVal,
) *Handler {
	return &Handler{
		jwt:                jwt,
		sysData:            sysData,
		auth:               auth,
		userStore:          userStore,
		pricing:            pricing,
		orderStore:         orderStore,
		tracker:            tracker,
		cities:             cities,
		paymentOptions:     paymentOptions,
		shipmentCategories: shipmentCategories,
	}
}
