package postgres

import (
	"errors"
	"log"

	"golang.org/x/crypto/bcrypt"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

type CustomerStorage struct {
	DB *sqlx.DB
}

func (s CustomerStorage) UpdateUser(data *akwaba.Customer, userID uint) (newUser akwaba.Customer, err error) {
	var hashedPassword string
	err = s.DB.QueryRow(
		`SELECT password FROM customer WHERE id=$1`,
		userID,
	).Scan(&hashedPassword)

	err = bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(data.Password))
	if err != nil {
		log.Println(err)
		err = errors.New("Mot de passe incorrecte")
		return
	}

	err = s.DB.QueryRow(
		`UPDATE customer 
		SET full_name=$1, phone=$2, email=$3, address=$4
		WHERE id=$5
		RETURNING id, full_name, phone, email, address`,
		data.FullName, data.Phone, data.Email, data.Address, userID,
	).Scan(&newUser.ID, &newUser.FullName, &newUser.Phone, &newUser.Email, &newUser.Address)
	if err != nil {
		log.Println(err)
		err = errors.New("Erreur interne de mis à jour du profil")
		return
	}
	return
}

func (s CustomerStorage) CustomerByEmail(email string) (cust akwaba.Customer, err error) {
	err = s.DB.QueryRow(
		`SELECT customer_id, full_name, email, phone FROM customers WHERE email=$1`,
		email,
	).Scan(&cust.ID, &cust.FullName, &cust.Email, &cust.Phone)
	if err != nil {
		return
	}
	return
}

// Save method save new customer info into database
// and return customer struct from database with error
func (s CustomerStorage) Save(c *akwaba.Customer) (cust akwaba.Customer, err error) {
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(c.Password), bcrypt.MinCost)
	if err != nil {
		return
	}
	err = s.DB.QueryRow(
		`INSERT INTO customers (full_name, phone, email, password) VALUES ($1, $2, $3, $4) RETURNING customer_id`,
		c.FullName, c.Phone, c.Email, string(passwordHash),
	).Scan(&c.ID)
	if err != nil {
		if err.Error() == keyDuplicationError("customers_email_key") {
			err = errors.New(duplicateEmailErrr)
			return
		} else if err.Error() == keyDuplicationError("customers_phone_key") {
			err = errors.New(duplicatePhoneErr)
			return
		}
		log.Println(err)
		err = errors.New("Erreur interne du serveur")
	}
	cust = *c
	return
}
