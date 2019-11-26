package akwaba

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/lib/pq"
)

// Order states
const (
	OrderStatePendingID   uint8 = 1
	OrderInProcessingID   uint8 = 2
	OrderStateCompletedID uint8 = 3
	OrderStateCanceledID  uint8 = 4
)

// Order struct represent order that will be created by users
type Order struct {
	ID          uint64     `json:"id"`
	ShipmentID  NullInt64  `json:"shipmentId"`
	UserID      uint       `json:"userId"`
	State       OrderState `json:"state"`
	TimeCreated time.Time  `json:"timeCreated"`
	TimeClosed  NullTime   `json:"timeClosed"`
	OrderData
}

type OrderData struct {
	Sender        Address          `json:"sender"`
	Recipient     Address          `json:"recipient"`
	Category      ShipmentCategory `json:"category"`
	PaymentOption PaymentOption    `json:"paymentOption"`
	Nature        string           `json:"nature"`
	Cost          uint             `json:"cost"`
	Distance      float64          `json:"distance"`
}

// NullInt64 is an alias for sql.NullInt64 data type
type NullInt64 struct {
	sql.NullInt64
}

// MarshalJSON for NullInt64
func (ni *NullInt64) MarshalJSON() ([]byte, error) {
	if !ni.Valid {
		return []byte("null"), nil
	}
	return json.Marshal(ni.Int64)
}

// NullTime is an alias for mysql.NullTime data type
type NullTime struct {
	pq.NullTime
}

// MarshalJSON for NullTime
func (nt *NullTime) MarshalJSON() ([]byte, error) {
	if !nt.Valid {
		return []byte("null"), nil
	}
	val := fmt.Sprintf("\"%s\"", nt.Time.Format(time.RFC3339))
	return []byte(val), nil
}

type StateUpdater interface {
	UpdateState(ctx context.Context, ID uint64, stateID uint8) error
}

type OrdersGatherer interface {
	ActiveOrders(ctx context.Context) (o []Order, err error)
	ClosedOrders(ctx context.Context, date string) (o []Order, err error)
}

type OrderManager interface {
	ConfirmOrder(ctx context.Context, orderID uint64) (shipmentID uint64, err error)
	CreateShipment(ctx context.Context, orderID uint64) (shipmentID uint64, err error)
	// Cost(origin, destination string, categoryID uint8) (cost uint, distance float64, err error)
	OrdersGatherer
	OrderSaverCanceler
	UpdateState(ctx context.Context, orderID uint64, stateID uint8) error
}

type UserPicker interface {
	Users(ctx context.Context) []User
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
