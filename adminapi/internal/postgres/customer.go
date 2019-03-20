package postgres

import (
	"database/sql"

	"github.com/behouba/dsapi"
)

type UserStore struct {
	DB *sql.DB
}

func (cs *UserStore) GetUserByPhone(phone string) (user []dsapi.User, err error) {
	return
}

func (cs *UserStore) GetUserByName(name string) (user []dsapi.User, err error) {
	return
}

func (cs *UserStore) GetDeliveryAddress(userID int) (add []dsapi.Address, err error) {
	return
}

func (cs *UserStore) GetPickUpAddress(userID int) (add []dsapi.Address, err error) {
	return
}
func (cs *UserStore) SaveUser(user *dsapi.User) (err error) {
	return
}
func (cs *UserStore) SaveDeliveryAddress(userID int, address *dsapi.Address) (err error) {
	return
}
func (cs *UserStore) SavePickUpAddress(userID int, address *dsapi.Address) (err error) {
	return
}
func (cs *UserStore) FreezeUser(userID int) (err error) {
	return
}
func (cs *UserStore) UnFreezeUser(userID int) (err error) {
	return
}
