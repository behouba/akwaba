package postgres

import (
	"github.com/behouba/akwaba"

	"golang.org/x/crypto/bcrypt"
)

func (a *AdminDB) Login(emp *akwaba.Employee) (e akwaba.Employee, err error) {
	err = a.db.QueryRow(
		`SELECT 
		e.id, e.full_name, e.phone, e.email, e.login, 
		e.hashed_password, e.office_id, o.name
		FROM employee as e 
		LEFT JOIN office as o 
		ON e.office_id = o.id
		WHERE e.login=$1`,
		emp.Login,
	).Scan(&e.ID, &e.FullName, &e.Phone, &e.Email, &e.Login, &e.Password, &e.Office.ID, &e.Office.Name)
	if err != nil {
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(e.Password), []byte(emp.Password))
	if err != nil {
		return
	}
	return
}
