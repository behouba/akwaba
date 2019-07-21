package office

import (
	"github.com/behouba/akwaba"
)

type Handler struct {
	auth                 akwaba.TokenAuthService
	EmployeeAuthentifier akwaba.EmployeeAuthentifier
	shipmentStore        akwaba.ShipmentManager
}

func NewHandler(
	auth akwaba.TokenAuthService, orderStore akwaba.OrderManager,
	EmployeeAuthentifier akwaba.EmployeeAuthentifier,
	shipmentStore akwaba.ShipmentManager,
) *Handler {
	return &Handler{
		auth:                 auth,
		EmployeeAuthentifier: EmployeeAuthentifier,
		shipmentStore:        shipmentStore,
	}
}
