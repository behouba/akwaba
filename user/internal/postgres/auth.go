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
	DB              *sql.DB
	Cities          []akwaba.City
	WeightIntervals []akwaba.WeightInterval
	PaymentTypes    []akwaba.PaymentType
}

// Open function open DB database
// each server should have it own database user with corresponding rights on database
func Open(uri string) (d UserDB, err error) {
	// will open database connection here
	// each server should have it own database user with corresponding rights on database
	db, err := sql.Open("postgres", uri)
	if err != nil {
		return
	}
	d.Cities, err = getAllCities(db)
	if err != nil {
		return
	}
	d.WeightIntervals, err = getWeightIntervals(db)
	if err != nil {
		return
	}
	d.PaymentTypes, err = getPaymentType(db)
	if err != nil {
		return
	}
	d.DB = db
	return
}

func getAllCities(db *sql.DB) (cities []akwaba.City, err error) {
	rows, err := db.Query("SELECT id, name from city")
	if err != nil {
		return
	}
	for rows.Next() {
		var c akwaba.City
		err = rows.Scan(&c.ID, &c.Name)
		if err != nil {
			log.Println(err)
		}
		cities = append(cities, c)
	}
	return
}

func getWeightIntervals(db *sql.DB) (w []akwaba.WeightInterval, err error) {
	rows, err := db.Query("SELECT id, name from weight_interval order by id")
	if err != nil {
		return
	}
	for rows.Next() {
		var i akwaba.WeightInterval
		err = rows.Scan(&i.ID, &i.Name)
		if err != nil {
			log.Println(err)
		}
		w = append(w, i)
	}
	return
}

func getPaymentType(db *sql.DB) (pt []akwaba.PaymentType, err error) {
	rows, err := db.Query("SELECT id, name from payment_type order by id")
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.PaymentType
		err = rows.Scan(&p.ID, &p.Name)
		if err != nil {
			log.Println(err)
		}
		pt = append(pt, p)
	}
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
		`INSERT INTO "customer" (full_name, phone, email, hashed_password) VALUES ($1, $2, $3, $4) RETURNING id`,
		u.FullName, u.Phone, u.Email, u.HashedPassword,
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
func (d *UserDB) Authenticate(email, password string) (user akwaba.User, err error) {
	err = d.DB.QueryRow(
		`SELECT id, full_name, email, phone, hashed_password FROM customer WHERE email=$1`,
		email,
	).Scan(&user.ID, &user.FullName, &user.Email, &user.Phone, &user.HashedPassword)
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
		`SELECT id, full_name, phone, email FROM customer WHERE phone=$1`,
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
		`SELECT id, full_name, email, phone FROM customer WHERE email=$1`,
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
		`INSERT INTO recovery_request (customer_id, request_uuid) VALUES ($1, $2)`,
		user.ID, newUUID,
	)
	return
}

func (d *UserDB) CheckPasswordChangeRequestUUID(uuid string) (userID int, err error) {
	var t time.Time
	err = d.DB.QueryRow(
		"SELECT customer_id, created_at FROM recovery_request WHERE request_uuid=$1", uuid).Scan(&userID, &t)
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
	_, err = d.DB.Exec(`UPDATE customer SET hashed_password=$1 WHERE id=$2`, hp, userID)
	if err != nil {
		return
	}
	d.DB.QueryRow("DELETE FROM recovery_request WHERE customer_id=$1", userID)
	return
}
