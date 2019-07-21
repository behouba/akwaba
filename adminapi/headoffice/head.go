package headoffice

import (
	"github.com/behouba/akwaba"
)

type Handler struct {
	auth                 akwaba.TokenAuthService
	EmployeeAuthentifier akwaba.EmployeeAuthentifier
	orderStore           akwaba.OrderManager
	customerStore        akwaba.CustomerPicker
	shipmentState        akwaba.StateUpdater
}

func NewHandler(
	auth akwaba.TokenAuthService, orderStore akwaba.OrderManager,
	EmployeeAuthentifier akwaba.EmployeeAuthentifier, customerStore akwaba.CustomerPicker,
) *Handler {
	return &Handler{
		auth:                 auth,
		orderStore:           orderStore,
		EmployeeAuthentifier: EmployeeAuthentifier,
		customerStore:        customerStore,
	}
}
