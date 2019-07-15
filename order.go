package akwaba

import (
	"fmt"
	"strings"
	"time"
)

// Order states
const (
	OrderStatePendingID   uint8 = 1
	OrderInProcessing     uint8 = 2
	OrderStateCompletedID uint8 = 3
	OrderStateCanceledID  uint8 = 4
)

// Order struct represent order that will be created by users
type Order struct {
	OrderID       uint64           `json:"orderId"`
	CustomerID    uint             `json:"customerId"`
	Sender        Address          `json:"sender"`
	Recipient     Address          `json:"recipient"`
	Category      ShipmentCategory `json:"category"`
	PaymentOption PaymentOption    `json:"paymentOption"`
	State         OrderState       `json:"state"`
	TimeCreated   time.Time        `json:"timeCreated"`
	TimeClosed    time.Time        `json:"timeClosed"`
	Nature        string           `json:"nature"`
	Cost          uint             `json:"cost"`
	Distance      float64          `json:"distance"`
}

type OrderService interface {
	OrderByID(orderID uint64) (order Order, err error)
	CustomerOrders(userID uint) (orders []Order, err error)
	Save(order *Order) (err error)
	Cancel(orderID uint64) (err error)
}

// OrderState data type represent order state id and corresponding label
type OrderState struct {
	ID   uint8  `json:"id"`
	Name string `json:"name"`
}

// PaymentOption data type represent payement options
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

func (o Order) FormatTimeFR() (formatted string) {
	timeString := strings.Join(
		strings.Split(
			fmt.Sprintf(o.TimeCreated.Format("15:04:05")), ":",
		)[:2], ":",
	)
	var month string
	switch o.TimeCreated.Month().String() {
	case "January":
		month = "Janvier"
	case "February":
		month = "Février"
	case "March":
		month = "Mars"
	case "April":
		month = "Avril"
	case "May":
		month = "Mai"
	case "June":
		month = "Juin"
	case "July":
		month = "Juillet"
	case "August":
		month = "Août"
	case "September":
		month = "Septembre"
	case "October":
		month = "Octobre"
	case "November":
		month = "Novembre"
	case "December":
		month = "Décembre"
	}
	formatted = fmt.Sprintf(
		"%d %s, %d à %s",
		o.TimeCreated.Day(),
		month, o.TimeCreated.Year(),
		timeString,
	)
	return
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
	return
}
