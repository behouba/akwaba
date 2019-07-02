package postgres

import (
	"github.com/behouba/akwaba"
)

func (a *AdminDB) Contact(phone string) (c akwaba.Contact, err error) {
	err = a.db.QueryRow(
		`SELECT sender_phone  FROM delivery_order WHERE sender_phone=$1`,
		phone,
	).Scan(&c.Phone)
	if err != nil {
		err := a.db.QueryRow(
			`SELECT receiver_phone  FROM delivery_order WHERE receiver_phone=$1`,
			phone,
		).Scan(&c.Phone)
		if err != nil {
			return c, err
		}
		c.OrderCount, c.State = a.contactOrderCountAndState(phone)
		return c, err
	}
	c.OrderCount, c.State = a.contactOrderCountAndState(phone)
	return
}

func (a *AdminDB) contactOrderCountAndState(phone string) (count uint32, state string) {
	a.db.QueryRow(
		"SELECT COUNT(*) FROM delivery_order WHERE sender_phone=$1",
		phone,
	).Scan(&count)

	var p string
	a.db.QueryRow(
		"SELECT phone FROM black_list WHERE phone=$1",
		phone,
	).Scan(&p)
	if p != "" {
		state = "BLOQUÉ"
	} else {
		state = "ACTIF"
	}
	return
}

func (a *AdminDB) LockUser(phone string) (err error) {
	_, err = a.db.Exec("INSERT INTO black_list (phone) values ($1)", phone)
	return
}

func (a *AdminDB) UnlockUser(phone string) (err error) {
	_, err = a.db.Exec("DELETE FROM black_list WHERE phone=$1", phone)
	return
}
