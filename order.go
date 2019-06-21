package akwaba

import (
	"errors"
	"time"
)

// Order states
var (
	OrderPending       = OrderState{ID: 1}
	OrderWaitingPickUp = OrderState{ID: 2}
	OrderInProcessing  = OrderState{ID: 3}
	OrderClosed        = OrderState{ID: 4}
	OrderCanceled      = OrderState{ID: 5}
)

// Order struct represent order that will be created by users
type Order struct {
	OrderID        uint64         `json:"orderId,omitempty"`
	PaymentType    PaymentType    `json:"paymentType"`
	CustomerID     uint           `json:"customerId"`
	CreatedAt      EventTime      `json:"createdAt"`
	State          OrderState     `json:"state"`
	Cost           float64        `json:"cost"`
	Sender         Address        `json:"sender"`
	Receiver       Address        `json:"receiver"`
	WeightInterval WeightInterval `json:"weightInterval"`
	Nature         string         `json:"nature"`
	Note           string         `json:"note"`
}

// OrderState data type represent order state id and corresponding label
type OrderState struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}

// PaymentType
type PaymentType struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}

// City represent
type City struct {
	ID       uint8  `json:"id"`
	Name     string `json:"name"`
	OfficeID uint8  `json:"officeId"`
}

type WeightInterval struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}

// ComputeCost return totalCost of the order
func (o *Order) ComputeCost() (cost float64) {
	o.Cost = 3500
	return o.Cost
}

// Address represent delivery address provided by customers
type Address struct {
	ID uint64 `json:"id,omitempty"`
	// CustomerID  int      `json:"customerId"`
	City     City   `json:"city" binding:"required"`
	FullName string `json:"fullName" binding:"required"`
	Phone    string `json:"phone" binding:"required"`
	Address  string `json:"address" binding:"required"`
}

// Track represent an event in order journey
type Track struct {
	OrderID  uint64    `json:"orderId"`
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
