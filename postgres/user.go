package postgres

import (
	"database/sql"
	"errors"
	"log"

	"golang.org/x/crypto/bcrypt"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

type UserStore struct {
	db *sqlx.DB
}

func NewUserStore(db *sqlx.DB) *UserStore {
	return &UserStore{db: db}
}

func (s *UserStore) Update(data *akwaba.User) (err error) {
	err = s.saveOldDataBeforeUpdate(data.ID)
	if err != nil {
		return
	}
	_, err = s.db.Exec(
		`UPDATE users 
		SET first_name=$1, last_name=$2, phone=$3
		WHERE user_id=$4`,
		data.FirstName, data.LastName, data.Phone, data.ID,
	)
	if err != nil {
		log.Println(err)
		err = errors.New("Erreur interne de mis à jour du profil")
		return
	}
	return
}

func (s *UserStore) saveOldDataBeforeUpdate(custID uint) (err error) {
	var user akwaba.User
	err = s.db.QueryRow(
		`SELECT first_name, last_name, phone FROM users WHERE user_id=$1`,
		custID,
	).Scan(&user.FirstName, &user.LastName, &user.Phone)
	if err != nil {
		return
	}
	_, err = s.db.Exec(
		`INSERT INTO 
		user_updates 
		(user_id, first_name, last_name, phone) 
		VALUES ($1, $2, $3, $4);`,
		custID, user.FirstName, user.LastName, user.Phone,
	)
	if err != nil {
		return
	}
	return
}

func (s *UserStore) UpdatePassword(current, new string, custID uint) (err error) {
	var hashedPassword string

	err = s.db.QueryRow(
		"SELECT password FROM users WHERE user_id=$1",
		custID,
	).Scan(&hashedPassword)
	if err != nil {
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(current))
	if err != nil {
		err = errors.New("Mot de passe actuel incorrect")
		return
	}

	newHashedPassword, err := bcrypt.GenerateFromPassword([]byte(new), bcrypt.MinCost)
	if err != nil {
		return
	}
	_, err = s.db.Exec(
		`UPDATE users SET password=$1 WHERE user_id=$2`,
		newHashedPassword, custID,
	)
	return
}

func (s *UserStore) UserByEmail(email string) (user akwaba.User, err error) {
	err = s.db.QueryRow(
		`SELECT user_id, first_name, last_name, email, phone FROM users WHERE email=$1`,
		email,
	).Scan(&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.Phone)
	if err == sql.ErrNoRows {
		err = errors.New("L'email saisi est inconnu");
		return
	}
	return
}

// Save method save new user info into database
// and return user struct from database with error
func (s *UserStore) Save(c *akwaba.User) (err error) {
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(c.Password), bcrypt.MinCost)
	if err != nil {
		return
	}
	err = s.db.QueryRow(
		`INSERT INTO users (first_name, last_name, phone, email, password) VALUES ($1, $2, $3, $4, $5) RETURNING user_id`,
		c.FirstName, c.LastName, c.Phone, c.Email, string(passwordHash),
	).Scan(&c.ID)
	if err != nil {
		if err.Error() == keyDuplicationError("users_email_key") {
			err = errors.New(duplicateEmailErrr)
			return
		} else if err.Error() == keyDuplicationError("users_phone_key") {
			err = errors.New(duplicatePhoneErr)
			return
		}
		log.Println(err)
		err = errors.New("Erreur interne du serveur")
	}
	return
}
