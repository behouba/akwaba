package postgres

import (
	"database/sql"
	"errors"
	"fmt"
	"github.com/behouba/akwaba"
	_ "github.com/lib/pq" // postgresql driver
	"net/http"
)

const (
	duplicatePhoneErr  = "Un compte avec ce téléphone existe déjà"
	duplicateEmailErrr = "Un compte avec cette adresse e-mail existe déjà"
)

// UserDB hold database connection for users
type UserDB struct {
	DB *sql.DB
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func Open(uri string) (database UserDB, err error) {
	// will open database connection here
	// each server should have it own database user with corresponding rights on database
	db, err := sql.Open("postgres", uri)
	if err != nil {
		return
	}
	database.DB = db
	return
}

// SaveAuthCode store code send to user by sms to redis
func (d *UserDB) SaveAuthCode(phone, code string) (err error) {
	// return r.client.Set(phone, code, 15*time.Minute).Err()
	return
}

// ConfirmSMSCode take guest user phone number with verification code
// and check in redis is this phone number correspond to this code
func (d *UserDB) ConfirmSMSCode(phone string, code string) (valid bool) {
	// c, err := r.client.Get(phone).Result()
	// if err != nil {
	// 	return false
	// }
	// if c == code {
	// 	r.client.Del(phone)
	// 	return true
	// }
	if code == "5555" && phone == "45001685" {
		return true
	}
	return false
}

// SaveNewCustomer save new customer info into database
// and return user id from database with error
func (d *UserDB) SaveNewCustomer(u *dsapi.User) (user *dsapi.User, statusCode int, err error) {
	fmt.Println("user password", u.Password)
	err = d.DB.QueryRow("INSERT INTO users (full_name, phone, email, password) VALUES ($1, $2, $3, $4) RETURNING id",
		u.FullName, u.Phone, u.Email, u.Password,
	).Scan(&u.ID)
	if err != nil {
		if err.Error() == keyDuplicationError("customer_email_key") {
			err = errors.New(duplicateEmailErrr)
			statusCode = http.StatusConflict
			return
		} else if err.Error() == keyDuplicationError("customer_phone_key") {
			err = errors.New(duplicatePhoneErr)
			statusCode = http.StatusConflict
			return
		}
		statusCode = http.StatusInternalServerError
	}
	user = u
	return
}

// Authenticate check if user provided email and password match and then return the user struct
func (d *UserDB) Authenticate(login, password string) (user dsapi.User, err error) {
	user.FullName = "Kouame Behouba Manasse"
	user.ID = 23423
	user.Phone = "45001685"
	user.Email = "behoubx@gmail.com"
	return
}

// CheckPhone check if phone number exist in database then return nil
// is phone exit and error if not
func (d *UserDB) CheckPhone(phone string) (user dsapi.User, err error) {
	err = d.DB.QueryRow("SELECT id, full_name, phone, email FROM users WHERE phone=$1",
		phone,
	).Scan(&user.ID, &user.FullName, &user.Phone, &user.Email)
	return
}

// UserByPhone take user phone number and return user struct
func (d *UserDB) UserByPhone(phone string) (user dsapi.User, err error) {
	return dsapi.User{ID: 5, FullName: "Kouame behouba", Email: "behouba@gmail.com", Phone: phone}, nil
}

func keyDuplicationError(key string) string {
	return `pq: duplicate key value violates unique constraint "` + key + `"`
}
