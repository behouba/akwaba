package office

import (
	"github.com/behouba/akwaba"
)

type Handler struct {
	auth          akwaba.AdminAuthService
	employeeStore akwaba.EmployeeStore
	orderStore    akwaba.AdminOrderService
}

func NewHandler(
	auth akwaba.AdminAuthService, orderStore akwaba.AdminOrderService,
	employeeStore akwaba.EmployeeStore,
) *Handler {
	return &Handler{
		auth:          auth,
		orderStore:    orderStore,
		employeeStore: employeeStore,
	}
}
