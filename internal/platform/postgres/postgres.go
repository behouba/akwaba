package postgres

import (
	"database/sql"
	"fmt"

	"github.com/behouba/dsapi/internal/customer"
)

// DB hold database connection
type DB struct {
	db *sql.DB
}

// Open function open DB database
func Open() (database *DB, err error) {
	// will open database connection here
	return
}

// SaveNewCustomer save new customer info into database
// and return user id from database with error
func (d *DB) SaveNewCustomer(c customer.NewCustomer) (userID int, err error) {
	fmt.Println("user data saved to database")
	return
}

// CheckPhone check if phone number exist in database then return nil
// is phone exit and error if not
func (d *DB) CheckPhone(phone string) (userID int, err error) {
	return
}

// CustomerIDFromPhone take customer phone number and return customer id
func (d *DB) CustomerIDFromPhone(phone string) (id int, err error) {
	return 5, nil
}
