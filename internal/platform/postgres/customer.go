package postgres

import (
	"fmt"

	"github.com/behouba/dsapi/internal/customer"
)

// SaveNewCustomer save new customer info into database
// and return user id from database with error
func SaveNewCustomer(c customer.NewCustomer) (userID int, err error) {
	fmt.Println("user data saved to database")
	return
}

// CheckPhone check if phone number exist in database then return nil
// is phone exit and error if not
func CheckPhone(phone string) (userID int, err error) {
	return
}
