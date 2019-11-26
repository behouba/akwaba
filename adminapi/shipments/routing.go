package shipments

import (
	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

const (
	officeBaseURL    = "/office"
	authBaseURL      = "auth"
	shipmentsBaseURL = "/shipments"
)

func SetupShipmentsAPIEngine(
	r *gin.RouterGroup, auth akwaba.AdminTokenService,
	employeeStore akwaba.AdminAuthentifier,
	shipmentStore akwaba.ShipmentManager,
) (err error) {

	h := &handler{auth, employeeStore, shipmentStore}

	// offices api to manage shipments localy
	office := r.Group(officeBaseURL)
	{
		// office.GET("/system_data", g.systemData)
		// office.GET("/tracking", g.trackOrder)
		auth := office.Group(authBaseURL)
		{
			auth.GET("/check", h.AuthMiddleware())
			auth.POST("/login", h.Login)
		}
		p := office.Group(shipmentsBaseURL)
		p.Use(h.AuthMiddleware())
		{
			p.GET("/pickups", h.PickUps)
			p.GET("/stock", h.Stock)
			p.GET("/deliveries", h.Deliveries)

			p.PATCH("/picked_up", h.PickedUp)
			p.PATCH("/check_in", h.CheckIn)
			p.PATCH("/check_out", h.CheckOut)
			p.PATCH("/delivered", h.Delivered)
			p.PATCH("/failed_delivery", h.FailedDelivery)
		}
	}
	return
}

type handler struct {
	auth          akwaba.AdminTokenService
	employeeStore akwaba.AdminAuthentifier
	shipmentStore akwaba.ShipmentManager
}
