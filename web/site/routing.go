package site

import (
	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
)

const (
	authPath    = "/auth"
	orderPath   = "/order"
	profilePah  = "/profile"
	pricingPath = "/pricing"
)

// Router represents the website  handlers methods set
type handler struct {
	locationService   akwaba.LocationService
	pricingService    akwaba.PricingService
	accountStore      akwaba.AccountStore
	orderStore        akwaba.OrderStore
	tracker           akwaba.Tracker
	paymentOptionsMap map[uint8]string
	categoriesMap     map[uint8]string
}

// SetupWebsiteEngine set website routes on the given *gin.Engine
func SetupWebsiteEngine(
	e *gin.Engine,
	locationService akwaba.LocationService,
	pricingService akwaba.PricingService, accountStore akwaba.AccountStore,
	orderStore akwaba.OrderStore, tracker akwaba.Tracker,
	templatesPath, assetsPath string,
) (err error) {
	r, err := newHandler(
		locationService,
		pricingService, accountStore,
		orderStore, tracker,
	)
	if err != nil {
		return
	}
	e.LoadHTMLGlob(templatesPath)
	e.Static("/assets", assetsPath)
	store := cookie.NewStore([]byte("akwaba"))
	e.Use(sessions.Sessions("akwaba-auth", store))
	// gin.SetMode(gin.ReleaseMode)

	auth := e.Group(authPath)
	auth.Use(r.alreadyAuthenticated)
	{
		auth.GET("/login", r.loginHTML)
		auth.POST("/login", r.handleLoginForm)
		auth.GET("/registration", r.registrationHTML)
		auth.POST("/registration", r.handleRegistrationForm)
		auth.GET("/recovery", r.recoveryHTML)
		auth.GET("/change-password", r.changePasswordHTML)
	}

	order := e.Group(orderPath)
	{
		order.GET("/pricing", r.orderPricingHTML)
		order.GET("/form", r.authRequired, r.orderForm)
		order.GET("/success", r.authRequired, r.orderSuccess)
	}

	profile := e.Group(profilePah)
	profile.Use(r.authRequired)
	{
		profile.GET("/settings", r.settingsHTML)
		profile.GET("/my_orders", r.userOrdersHTML)
		profile.GET("/update-password", r.updatePasswordHTML)
	}

	e.GET("/auth/logout", r.logout)

	e.GET("/", r.homeHTML)
	e.GET("/services", r.servicesHTML)
	e.GET("/tracking", r.trackingHTML)
	e.GET("/about", r.aboutHTML)
	e.GET("/general-conditions", r.conditionsHTML)
	e.GET("/privacy-policy", r.privacyPolicyHTML)

	e.NoRoute(func(c *gin.Context) {
		c.HTML(404, "404", nil)
	})
	return
}

// NewHandler make new website router
func newHandler(
	locationService akwaba.LocationService,
	pricingService akwaba.PricingService, accountStore akwaba.AccountStore,
	orderStore akwaba.OrderStore, tracker akwaba.Tracker,
) (*handler, error) {

	paymentOptionsMap, _, err := pricingService.PaymentOptions()
	if err != nil {
		return nil, err
	}
	categoriesMap, _, err := pricingService.ShipmentCategories()
	if err != nil {
		return nil, err
	}
	return &handler{
		locationService:   locationService,
		accountStore:      accountStore,
		pricingService:    pricingService,
		orderStore:        orderStore,
		tracker:           tracker,
		paymentOptionsMap: paymentOptionsMap,
		categoriesMap:     categoriesMap,
	}, nil
}
