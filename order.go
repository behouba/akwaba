package akwaba

import (
	"database/sql"
	"encoding/json"
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
	OrderID          uint64           `json:"orderId"`
	CustomerID       sql.NullInt64    `json:"customerId"`
	Sender           json.RawMessage  `json:"sender"`
	Receiver         json.RawMessage  `json:"receiver"`
	PaymentOption    PaymentOption    `json:"paymentOption"`
	ShipmentCategory ShipmentCategory `json:"shipmentCategory"`
	SenderCity       City             `json:"origin"`
	ReceiverCity     City             `json:"destination"`
	State            OrderState       `json:"state"`
	Cost             uint16           `json:"cost"`
	CreatedAt        EventTime        `json:"createdAt"`
	Nature           string           `json:"nature"`
}

// OrderState data type represent order state id and corresponding label
type OrderState struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}

// PaymentOption
type PaymentOption struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}

// City represent
type City struct {
	ID       uint8  `json:"id"`
	Name     string `json:"name"`
	OfficeID uint8  `json:"officeId"`
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
	// if len(o.Sender.Name) < 1 {
	// 	return errors.New("Veuillez saisir le nom de l'expediteur")
	// }
	// if len(o.Sender.Phone) != 16 {
	// 	return errors.New("Veuillez saisir un numéro de mobile valide")
	// }
	// if o.Sender.City.ID == 0 {
	// 	return errors.New("Veuillez selectionner une commune")
	// }
	// if len(o.Sender.Address.Place.Formal) < 1 {
	// 	return errors.New("Veuillez saisir l'adresse pour l'expediteur")
	// }
	// if len(o.Receiver.Name) < 1 {
	// 	return errors.New("Veuillez saisir le nom du destinataire")
	// }
	// if len(o.Receiver.Phone) != 16 {
	// 	return errors.New("Veuillez saisir un numéro de mobile valide")
	// }
	// if o.Receiver.City.ID == 0 {
	// 	return errors.New("Veuillez selectionner une commune")
	// }
	// if len(o.Receiver.Address.Place.Formal) < 1 {
	// 	return errors.New("Veuillez saisir l'adresse pour le destinataire")
	// }
	if o.ShipmentCategory.ID == 0 {
		return errors.New("Veuillez selectionner un interval de poids")
	}
	return
}
