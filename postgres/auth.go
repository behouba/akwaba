package postgres

import (
	"errors"
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
	noResltErr         = "sql: no rows in result set"
)

// Authenticator is the implementation of UserAuthentifier interface
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
func (a *Authenticator) Authenticate(email, password, ip string) (user akwaba.User, err error) {
	var passwordHash string
	err = a.db.QueryRow(
		`SELECT 
		user_id, first_name, last_name, email, 
		phone, password
		FROM users
		WHERE email=$1`,
		email,
	).Scan(
		&user.ID, &user.FirstName, &user.LastName,
		&user.Email,
		&user.Phone, &passwordHash,
	)
	if err != nil {
		user.Password = password
		if err.Error() == noResltErr {
			err = errors.New("Nom d’utilisateur ou mot de passe incorrect")
		}
		return
	}
	err = bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(password))
	if err != nil {
		user.Password = password
		err = errors.New("Nom d’utilisateur ou mot de passe incorrect")
		return
	}
	a.recordLogin(user.ID, ip)
	return
}

func (a *Authenticator) recordLogin(custID uint, ip string) (err error) {
	_, err = a.db.Exec(
		`INSERT INTO users_access_history (user_id, ip_address) VALUES ($1, $2)`,
		custID, ip,
	)
	if err != nil {
		log.Println(err)
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
		`UPDATE users SET recovery_token=$1 WHERE email=$2`,
		token, email,
	)
	return
}

func (d *Authenticator) CheckRecoveryToken(token string) (custID uint, err error) {
	err = d.db.QueryRow(
		"SELECT user_id FROM users WHERE recovery_token=$1",
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
	_, err = d.db.Exec(`UPDATE users SET password=$1 WHERE user_id=$2`, string(hp), userID)
	if err != nil {
		return
	}
	_, err = d.db.Exec("UPDATE users SET recovery_token=null, is_email_verified=true WHERE user_id=$1", userID)
	if err != nil {
		log.Println(err)
		// don't care about this error
		err = nil
	}
	return
}
