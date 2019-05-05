package postgres

import (
	"database/sql"
	"errors"
	"log"
	"net/http"
	"time"

	"golang.org/x/crypto/bcrypt"

	"github.com/behouba/akwaba"
	_ "github.com/lib/pq" // postgresql driver
	uuid "github.com/satori/go.uuid"
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
func (d *UserDB) SaveNewCustomer(u *akwaba.User) (user *akwaba.User, statusCode int, err error) {
	err = u.HashPassword()
	if err != nil {
		statusCode = http.StatusBadRequest
		return
	}
	err = d.DB.QueryRow(
		`INSERT INTO "user" (full_name, phone, email, password) VALUES ($1, $2, $3, $4) RETURNING id`,
		u.FullName, u.Phone, u.Email, u.Password,
	).Scan(&u.ID)
	if err != nil {
		if err.Error() == keyDuplicationError("users_email_key") {
			err = errors.New(duplicateEmailErrr)
			statusCode = http.StatusConflict
			return
		} else if err.Error() == keyDuplicationError("users_phone_key") {
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
func (d *UserDB) Authenticate(email, password string) (user akwaba.User, err error) {
	err = d.DB.QueryRow(
		`SELECT id, full_name, email, phone, password FROM "user" WHERE email=$1`,
		email,
	).Scan(&user.ID, &user.FullName, &user.Email, &user.Phone, &user.Password)
	if err != nil {
		user.Password = password
		return
	}
	err = user.ComparePassword(password)
	if err != nil {
		user.Password = password
		return
	}
	return
}

// CheckPhone check if phone number exist in database then return nil
// is phone exit and error if not
func (d *UserDB) CheckPhone(phone string) (user akwaba.User, err error) {
	err = d.DB.QueryRow(
		`SELECT id, full_name, phone, email FROM "user" WHERE phone=$1`,
		phone,
	).Scan(&user.ID, &user.FullName, &user.Phone, &user.Email)
	return
}

// UserByPhone take user phone number and return user struct
func (d *UserDB) UserByPhone(phone string) (user akwaba.User, err error) {
	return akwaba.User{ID: 5, FullName: "Kouame behouba", Email: "behouba@gmail.com", Phone: phone}, nil
}

func keyDuplicationError(key string) string {
	return `pq: duplicate key value violates unique constraint "` + key + `"`
}

func (d *UserDB) GetUserByEmail(email string) (user akwaba.User, err error) {

	err = d.DB.QueryRow(
		`SELECT id, full_name, email, phone FROM "user" WHERE email=$1`,
		email,
	).Scan(&user.ID, &user.FullName, &user.Email, &user.Phone)
	if err != nil {
		return
	}
	return
}

func (d *UserDB) SavePasswordRecoveryRequest(user *akwaba.User) (newUUID string, err error) {
	newUUID = uuid.NewV4().String()
	_, err = d.DB.Exec(
		`INSERT INTO recovery_request (user_id, uuid) VALUES ($1, $2)`,
		user.ID, newUUID,
	)
	return
}

func (d *UserDB) CheckPasswordChangeRequestUUID(uuid string) (userID int, err error) {
	var t time.Time
	err = d.DB.QueryRow(
		"SELECT user_id, create_time FROM recovery_request WHERE uuid=$1", uuid).Scan(&userID, &t)
	if err != nil {
		return
	}
	log.Println("db time = ", t)
	currentTime := time.Now().UTC()
	diff := currentTime.Sub(t)
	log.Println("current = ", currentTime)

	log.Println("time diff = ", diff)
	if diff.Hours() > 3 {
		err = errors.New("Le lien de recupération de mot de passe demandé n'existe pas ou a expiré")
		return
	}
	return
}

func (d *UserDB) ChangePassword(userID int, uuid, newPassword string) (err error) {
	hp, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.MinCost)
	if err != nil {
		return
	}
	_, err = d.DB.Exec(`UPDATE "user" SET password=$1 WHERE id=$2`, hp, userID)
	if err != nil {
		return
	}
	d.DB.QueryRow("DELETE FROM recovery_request WHERE user_id=$1", userID)
	return
}
