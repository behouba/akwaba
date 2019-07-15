package headoffice

import (
	"github.com/behouba/akwaba"
)

type Handler struct {
	auth          akwaba.AdminAuthService
	employeeStore akwaba.EmployeeStore
	orderStore    akwaba.AdminOrderService
	customerStore akwaba.AdminCustomerService
}

func NewHandler(
	auth akwaba.AdminAuthService, orderStore akwaba.AdminOrderService,
	employeeStore akwaba.EmployeeStore, customerStore akwaba.AdminCustomerService,
) *Handler {
	return &Handler{
		auth:          auth,
		orderStore:    orderStore,
		employeeStore: employeeStore,
		customerStore: customerStore,
	}
}
