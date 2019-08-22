package office

import (
	"github.com/behouba/akwaba"
)

type Handler struct {
	auth                 akwaba.AdminTokenService
	employeeAuthentifier akwaba.EmployeeAuthentifier
	shipmentStore        akwaba.ShipmentManager
}

func NewHandler(
	auth akwaba.AdminTokenService,
	employeeAuthentifier akwaba.EmployeeAuthentifier,
	shipmentStore akwaba.ShipmentManager,
) *Handler {
	return &Handler{
		auth:                 auth,
		employeeAuthentifier: employeeAuthentifier,
		shipmentStore:        shipmentStore,
	}
}
