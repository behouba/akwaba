package customer

import (
	"encoding/json"
	"errors"
	"strconv"
)

var (
	errInvalidPhone       = errors.New("Le numéro de téléphone fourni est invalid")
	errFullNameIsRequired = errors.New("Merci de fournir votre nom complet")
)

// NewCustomer is representation of new customer
// registration's data
type NewCustomer struct {
	FirstName string  `json:"firstName"`
	LastName  string  `json:"lastName"`
	TownID    int     `json:"townId"`
	Phone     string  `json:"phone"`
	Email     string  `json:"email"`
	PostionX  float32 `json:"positionX"`
	PostionY  float32 `json:"positionY"`
}

// ParseCustomerInfo validate new customer information
// before registration
func ParseCustomerInfo(bs []byte) (customer NewCustomer, err error) {
	err = json.Unmarshal(bs, &customer)
	if err != nil {
		return
	}
	if len(customer.Phone) != 8 {
		err = errInvalidPhone
		return
	}
	if _, e := strconv.Atoi(customer.Phone); e != nil {
		err = errInvalidPhone
		return
	}
	if customer.FirstName == "" || customer.LastName == "" {
		err = errFullNameIsRequired
		return
	}
	return
}
