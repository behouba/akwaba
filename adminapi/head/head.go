package head

import (
	"github.com/behouba/akwaba"
)

type Handler struct {
	auth                 akwaba.AdminTokenService
	EmployeeAuthentifier akwaba.EmployeeAuthentifier
	orderStore           akwaba.OrderManager
	userStore            akwaba.UserPicker
	shipmentState        akwaba.StateUpdater
}

func NewHandler(
	auth akwaba.AdminTokenService, orderStore akwaba.OrderManager,
	EmployeeAuthentifier akwaba.EmployeeAuthentifier, userStore akwaba.UserPicker,
) *Handler {
	return &Handler{
		auth:                 auth,
		orderStore:           orderStore,
		EmployeeAuthentifier: EmployeeAuthentifier,
		userStore:            userStore,
	}
}
