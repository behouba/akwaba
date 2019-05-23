package akwaba

import (
	"errors"
	"time"
)

// Order states id constants values
const (
	OrderStateWaitingConfirmation = 1
	OrderStateWaitingPickUp       = 2
	OrderStateInProcessing        = 3
	OrderStateClosed              = 4
	OrderStateCanceled            = 5
)

// Order struct represent order that will be created by users
type Order struct {
	ID             int            `json:"id,omitempty"`
	PaymentType    PaymentType    `json:"paymentTypeId"`
	CustomerID     int            `json:"customerId"`
	CreatedAt      EventTime      `json:"createdAt"`
	State          State          `json:"state"`
	Cost           float64        `json:"cost"`
	Sender         Address        `json:"sender"`
	Receiver       Address        `json:"receiver"`
	WeightInterval WeightInterval `json:"weightInterval"`
	Nature         string         `json:"nature"`
	Note           string         `json:"note"`
}

// State
type State struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

// PaymentType
type PaymentType struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

// City represent
type City struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type WeightInterval struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

// ComputeCost return totalCost of the order
func (o *Order) ComputeCost() (cost float64) {
	o.Cost = 3500
	return o.Cost
}

// Address represent delivery address provided by customers
type Address struct {
	ID int `json:"id,omitempty"`
	// CustomerID  int      `json:"customerId"`
	City     City   `json:"city" binding:"required"`
	FullName string `json:"fullName" binding:"required"`
	Phone    string `json:"phone" binding:"required"`
	Address  string `json:"address" binding:"required"`
}

// Track represent an event in order journey
type Track struct {
	OrderID  int       `json:"orderId"`
	Time     time.Time `json:"time"`
	OfficeID int       `json:"officeId"`
	EventID  int       `json:"eventId"`
}

// ValidateData function help validate data into new order before creation
func (o *Order) ValidateData() (err error) {
	// make checks and verification here
	if len(o.Sender.FullName) < 1 {
		return errors.New("Veuillez saisir le nom de l'expediteur")
	}
	if len(o.Sender.Phone) != 16 {
		return errors.New("Veuillez saisir un numéro de mobile valide")
	}
	if o.Sender.City.ID == 0 {
		return errors.New("Veuillez selectionner une commune")
	}
	if len(o.Sender.Address) < 1 {
		return errors.New("Veuillez saisir l'adresse pour l'expediteur")
	}
	if len(o.Receiver.FullName) < 1 {
		return errors.New("Veuillez saisir le nom du destinataire")
	}
	if len(o.Receiver.Phone) != 16 {
		return errors.New("Veuillez saisir un numéro de mobile valide")
	}
	if o.Receiver.City.ID == 0 {
		return errors.New("Veuillez selectionner une commune")
	}
	if len(o.Receiver.Address) < 1 {
		return errors.New("Veuillez saisir l'adresse pour le destinataire")
	}
	if o.WeightInterval.ID == 0 {
		return errors.New("Veuillez selectionner un interval de poids")
	}
	return
}
