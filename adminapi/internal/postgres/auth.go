package postgres

import (
	"database/sql"
	"errors"

	"github.com/behouba/dsapi"
)

// AdminDB hold database connection for admin users
type AdminDB struct {
	db *sql.DB
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func Open() (database *AdminDB, err error) {
	// each server should have it own database user with corresponding rights on database

	// will open database connection here
	return
}

// CheckCredential check if given employee credentials are allowed to login
func (a *AdminDB) CheckCredential(empAuth *dsapi.EmployeeAuthData) (emp *dsapi.Employee, err error) {
	emp1 := dsapi.EmployeeAuthData{Email: "behouba@gmail.com", Password: "12345"}
	emp2 := dsapi.EmployeeAuthData{Email: "manasse@gmail.com", Password: "54321"}

	if (emp1.Email == empAuth.Email && emp1.Password == empAuth.Password) || (emp2.Email == empAuth.Email && emp2.Password == empAuth.Password) {
		emp = &dsapi.Employee{ID: 5, OfficeID: 2, PositionID: 3}
		return
	}
	err = errors.New("invalid credential info, you are not allowed to login")
	return
}
