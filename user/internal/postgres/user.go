package postgres

import (
	"errors"
	"log"

	"github.com/behouba/akwaba"
)

func (d *UserDB) UpdateUser(data *akwaba.User, userID int) (newUser akwaba.User, err error) {
	var hashedPassword string
	err = d.db.QueryRow(
		`SELECT hashed_password FROM customer WHERE id=$1`,
		userID,
	).Scan(&hashedPassword)

	log.Println("hash from db: ", hashedPassword)
	err = data.CompareHashWithPassword(hashedPassword)
	if err != nil {
		log.Println(err)
		err = errors.New("Mot de passe incorrecte")
		return
	}
	if data.City.ID != 0 {
		err = d.db.QueryRow(
			`UPDATE customer 
			SET full_name=$1, phone=$2, email=$3, city_id=$4, address=$5
			WHERE id=$6
			RETURNING id, full_name, phone, email, city_id, address`,
			data.FullName, data.Phone, data.Email, data.City.ID, data.Address, userID,
		).Scan(&newUser.ID, &newUser.FullName, &newUser.Phone, &newUser.Email, &newUser.City.ID, &newUser.Address)
	} else {
		err = d.db.QueryRow(
			`UPDATE customer 
			SET full_name=$1, phone=$2, email=$3, address=$4
			WHERE id=$5
			RETURNING id, full_name, phone, email, address`,
			data.FullName, data.Phone, data.Email, data.Address, userID,
		).Scan(&newUser.ID, &newUser.FullName, &newUser.Phone, &newUser.Email, &newUser.Address)
	}

	if err != nil {
		log.Println(err)
		err = errors.New("Erreur interne de mis à jour du profil")
		return
	}
	return
}
