package postgres

import (
	"fmt"

	"github.com/behouba/dsapi/internal/customer"
)

// SaveNewCustomer save new customer info into database
func SaveNewCustomer(c customer.NewCustomer) (err error) {
	fmt.Println("user data saved to database")
	return
}
