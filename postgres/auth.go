package postgres

import (
	"log"
	"time"

	"github.com/jmoiron/sqlx"

	"golang.org/x/crypto/bcrypt"

	"github.com/behouba/akwaba"
	_ "github.com/lib/pq" // postgresql driver
)

const (
	duplicatePhoneErr  = "Un compte avec ce téléphone existe déjà"
	duplicateEmailErrr = "Un compte avec cette adresse e-mail existe déjà"
)

// Authenticator is the implementation of CustomerAuthentifier interface
type Authenticator struct {
	db *sqlx.DB
}

func NewAuthenticator(db *sqlx.DB) *Authenticator {
	return &Authenticator{db: db}
}

func keyDuplicationError(key string) string {
	return `pq: duplicate key value violates unique constraint "` + key + `"`
}

// Authenticate check if user provided email and password match and then return the user struct
func (d *Authenticator) Authenticate(email, password string) (cust akwaba.Customer, err error) {
	var passwordHash string
	err = d.db.QueryRow(
		`SELECT 
		customer_id, full_name, email, 
		phone, password, address
		FROM customers
		WHERE email=$1`,
		email,
	).Scan(
		&cust.ID, &cust.FullName, &cust.Email,
		&cust.Phone, &passwordHash,
		&cust.Address,
	)
	if err != nil {
		cust.Password = password
		return
	}
	err = bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(password))
	if err != nil {
		cust.Password = password
		return
	}
	return
}

func (d *Authenticator) SetRecoveryToken(email string) (token string, err error) {
	unixTimeString := string(time.Now().Unix())

	bs, err := bcrypt.GenerateFromPassword([]byte(unixTimeString), bcrypt.DefaultCost)
	if err != nil {
		return
	}
	token = string(bs)
	_, err = d.db.Exec(
		`UPDATE customers SET recovery_token=$1 WHERE email=$2`,
		token, email,
	)
	return
}

func (d *Authenticator) CheckRecoveryToken(token string) (custID uint, err error) {
	err = d.db.QueryRow(
		"SELECT customer_id FROM customers WHERE recovery_token=$1",
		token,
	).Scan(&custID)
	if err != nil {
		return
	}
	return
}

func (d *Authenticator) UpdatePassword(userID uint, token, newPassword string) (err error) {
	hp, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.MinCost)
	if err != nil {
		return
	}
	_, err = d.db.Exec(`UPDATE customers SET password=$1 WHERE customer_id=$2`, string(hp), userID)
	if err != nil {
		return
	}
	_, err = d.db.Exec("UPDATE customers SET recovery_token=null, is_email_verified=true WHERE customer_id=$1", userID)
	if err != nil {
		log.Println(err)
		// don't care about this error
		err = nil
	}
	return
}

// CheckPhone check if phone number exist in database then return nil
// is phone exit and error if not
// func (d *Authenticator) CheckPhone(phone string) (user akwaba.Customer, err error) {
// 	err = d.db.QueryRow(
// 		`SELECT id, full_name, phone, email FROM customer WHERE phone=$1`,
// 		phone,
// 	).Scan(&user.ID, &user.FullName, &user.Phone, &user.Email)
// 	return
// }

// UserByPhone take user phone number and return user struct
// func (d *Authenticator) UserByPhone(phone string) (user akwaba.Customer, err error) {
// 	return akwaba.Customer{ID: 5, Name: "Kouame behouba", Email: "behouba@gmail.com", Phone: phone}, nil
// }
