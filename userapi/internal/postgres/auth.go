package postgres

import (
	"database/sql"
	"fmt"

	"github.com/behouba/dsapi"
)

// UserDB hold database connection for users
type UserDB struct {
	db *sql.DB
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func Open() (database *UserDB, err error) {
	// will open database connection here
	// each server should have it own database user with corresponding rights on database
	return
}

// SaveNewCustomer save new customer info into database
// and return user id from database with error
func (d *UserDB) SaveNewCustomer(u *dsapi.User) (userID int, err error) {
	fmt.Println("user data saved to database")
	return
}

// CheckPhone check if phone number exist in database then return nil
// is phone exit and error if not
func (d *UserDB) CheckPhone(phone string) (userID int, err error) {
	return
}

// CustomerIDFromPhone take customer phone number and return customer id
func (d *UserDB) CustomerIDFromPhone(phone string) (id int, err error) {
	return 5, nil
}
