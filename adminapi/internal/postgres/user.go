package postgres

import (
	"database/sql"
	"log"

	"github.com/behouba/akwaba"
)

type UserStore struct {
	DB *sql.DB
}

const (
	pAddr = "pickup"
	dAddr = "delivery"
)

// GetUserByPhone retreive customer from database by phone
func (cs *UserStore) GetUserByPhone(phone string) (users []akwaba.User, err error) {
	rows, err := cs.DB.Query(
		`SELECT id, full_name, phone, email FROM customer WHERE phone=$1`,
		phone)
	if err != nil {
		return
	}

	for rows.Next() {
		var u akwaba.User
		err := rows.Scan(&u.ID, &u.FullName, &u.Phone, &u.Email)
		if err != nil {
			log.Println(err)
			continue
		}
		users = append(users, u)
	}
	return
}

// GetUserByName retreive user from database by their name
func (cs *UserStore) GetUserByName(name string) (users []akwaba.User, err error) {
	rows, err := cs.DB.Query(
		`SELECT id, full_name, phone, email FROM customer WHERE full_name ~ $1`,
		name)
	if err != nil {
		return
	}

	for rows.Next() {
		var u akwaba.User
		err := rows.Scan(&u.ID, &u.FullName, &u.Phone, &u.Email)
		if err != nil {
			log.Println(err)
			continue
		}
		users = append(users, u)
	}
	return
}

func (cs *UserStore) SaveAddress(addr *akwaba.Address) (id int, err error) {
	// switch addr.Type {
	// case dAddr:
	// 	err = cs.DB.QueryRow(
	// 		`INSERT
	// 		INTO delivery_address (full_name, phone, description, area_id, customer_id, longitude, latitude )
	// 		VALUES ($1, $2, $3, $4, $5, $6, $7)
	// 		RETURNING id`,
	// 		addr.FullName, addr.Phone, addr.Description, addr.AreaID,
	// 		addr.CustomerID, addr.Map.Longitude, addr.Map.Latitude,
	// 	).Scan(&id)
	// case pAddr:
	// 	err = cs.DB.QueryRow(
	// 		`INSERT
	// 			INTO pickup_address (customer_id, description, area_id, longitude, latitude )
	// 			VALUES ($1, $2, $3, $4, $5)
	// 			RETURNING id`,
	// 		addr.CustomerID, addr.Description, addr.AreaID, addr.Map.Longitude, addr.Map.Latitude,
	// 	).Scan(&id)
	// default:
	// 	return 0, errors.New("invalid address type")
	// }
	return
}

func (cs *UserStore) GetAddresses(userID int, addressType string) (add []akwaba.Address, err error) {
	var rows *sql.Rows
	if addressType == dAddr {
		rows, err = cs.DB.Query(
			`SELECT address_id FROM orders WHERE customer_id=$1`,
			userID,
		)
	} else if addressType == pAddr {
		rows, err = cs.DB.Query(
			`SELECT
			 parcel.address_id 
			 FROM 
			 orders 
			 INNER JOIN parcel ON orders.id = parcel.order_id 
			 WHERE orders.customer_id=$1`,
			userID,
		)
	}

	for rows.Next() {
		var id int
		if err := rows.Scan(&id); err != nil {
			log.Println(err)
			continue
		}
		a, err := cs.getAddressByID(id, addressType)
		if err != nil {
			log.Println(err)
			continue
		}
		add = append(add, a)
	}
	return
}

func (cs *UserStore) SaveUser(user *akwaba.User) (id int, err error) {
	err = cs.DB.QueryRow(
		`INSERT INTO customer (full_name, phone, email) VALUES ($1, $2, $3) RETURNING id`,
		user.FullName, user.Phone, user.Email,
	).Scan(&id)
	return
}

func (cs *UserStore) FreezeUser(userID int) (err error) {
	_, err = cs.DB.Exec(
		`UPDATE customer SET state_id=$1 WHERE id=$2`,
		akwaba.FreezedUserSateID, userID,
	)
	return
}
func (cs *UserStore) UnFreezeUser(userID int) (err error) {
	_, err = cs.DB.Exec(
		`UPDATE customer SET state_id=$1 WHERE id=$2`,
		akwaba.ActiveUserStateID, userID,
	)
	return
}

func (cs *UserStore) getAddressByID(id int, addressType string) (a akwaba.Address, err error) {
	// a.ID = id
	// if addressType == "delivery" {
	// 	err = cs.DB.QueryRow(
	// 		`SELECT
	// 		full_name,
	// 		phone,
	// 		description,
	// 		map_position,
	// 		area_id
	// 		FROM delivery_address
	// 		WHERE id=$1`,
	// 		id,
	// 	).Scan(&a.FullName, &a.Phone, &a.Description, &a.Map, &a.AreaID)
	// } else if addressType == "pickup" {
	// 	err = cs.DB.QueryRow(
	// 		`SELECT
	// 		full_name,
	// 		phone,
	// 		description,
	// 		map_position,
	// 		area_id
	// 		FROM pickup_address
	// 		WHERE id=$1`,
	// 		id,
	// 	).Scan(&a.FullName, &a.Phone, &a.Description, &a.Map, &a.AreaID)
	// }
	// if err != nil {
	// 	return
	// }
	return
}
