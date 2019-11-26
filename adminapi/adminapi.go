package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"time"

	"github.com/behouba/akwaba/adminapi/shipments"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/adminapi/orders"
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
	custBaseURL       = "/user"
)

var corsConfig = cors.New(cors.Config{
	AllowOrigins:     []string{"*"},
	AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
	AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Authorization"},
	AllowCredentials: true,
	MaxAge:           12 * time.Hour,
})

// SetupAdminAPIEngine create routes and return *gin.Engine
func SetupAdminAPIEngine(
	ordersManagerAuthToken akwaba.AdminTokenService,
	shipmentsManagerAuthToken akwaba.AdminTokenService,
	orderStore akwaba.OrderManager,
	ordersManagerAuthentifier akwaba.AdminAuthentifier,
	shipmentsManagerAuthentifier akwaba.AdminAuthentifier,
	userStore akwaba.UserPicker,
	shipmentState akwaba.StateUpdater,
	shipmentStore akwaba.ShipmentManager,
	pricingService akwaba.PricingService,
	locationService akwaba.LocationService,
) (*gin.Engine, error) {
	e := gin.Default()

	e.Use(corsConfig)
	v := e.Group(version)
	// v.GET("/pricing", h.ComputePrice)
	// v.GET("/tracking", g.trackOrder)
	// v.GET("/system_data", g.systemData)
	{
		orders.SetupOrdersAPIEngine(
			v, ordersManagerAuthToken, orderStore,
			ordersManagerAuthentifier,
			userStore, shipmentState,
			pricingService, locationService,
		)

		err := shipments.SetupShipmentsAPIEngine(
			v, shipmentsManagerAuthToken, shipmentsManagerAuthentifier, shipmentStore,
		)
		if err != nil {
			return nil, err
		}
	}
	return e, nil
}

type handler struct {
	tracker akwaba.Tracker
	sysData akwaba.SystemData
}
