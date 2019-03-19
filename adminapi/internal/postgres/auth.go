package postgres

import (
	"database/sql"
	"errors"
	"fmt"

	"golang.org/x/crypto/bcrypt"

	"github.com/behouba/dsapi"
)

// AdminDB hold database connection for admin users
type AdminDB struct {
	db *sql.DB
}

// AuthStore implement the AdminAuthenticator interface
type AuthStore struct {
	Db *sql.DB
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func Open(port int, host, username, password, dbname string) *sql.DB {

	psqlInfo := fmt.Sprintf(
		`host=%s port=%d user=%s password=%s dbname=%s sslmode=disable`,
		host, port, username, password, dbname,
	)
	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}

	err = db.Ping()
	if err != nil {
		panic(err)
	}
	fmt.Printf("Successfully connected to %s database \n", dbname)
	return db
}

// Check check if given employee credentials are allowed to login
func (a *AuthStore) Check(auth *dsapi.AdminCredential) (emp dsapi.Employee, err error) {
	var dbEmp dsapi.AdminCredential

	err = a.Db.QueryRow(
		`SELECT employee_id, user_name, password from employee_auth_data where user_name=$1`,
		auth.Name,
	).Scan(&dbEmp.ID, &dbEmp.Name, &dbEmp.Password)
	if err != nil {
		err = errors.New("invalid credential info, you are not allowed to login")
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(dbEmp.Password), []byte(auth.Password))
	if err != nil {
		return
	}

	err = a.Db.QueryRow(
		`SELECT full_name, position_id, office_id from employee where id=$1`,
		dbEmp.ID,
	).Scan(&emp.FullName, &emp.PositionID, &emp.OfficeID)

	if err != nil {
		return
	}
	return
}
