package akwaba

import (
	"fmt"
	"strings"
	"time"
)

// Differents order types identifier constants
const (
	OrderTypeOnline   = 1
	OrderTypeOnCall   = 2
	OrderTypeInOffice = 3
)

// Payement types identifier
const (
	PaymentBySender   = 1
	PaymentByReceiver = 2
)

// Events identifier constants
const (
	EventConfirmation       = 1
	EventPickedUp           = 2
	EventLeftOrigin         = 3
	EventAtTransitOffice    = 4
	EventLeftTransitOffice  = 5
	EventAtDeliveryOffice   = 6
	EventLeftDeliveryOffice = 7
	EventDelivered          = 8
	EventUserCancelation    = 9
	EventAdminCancelation   = 10
)

// TrackingEvent represent event emitted when parcel move.
type TrackingEvent struct {
	Time   EventTime `json:"time"`
	Status string    `json:"status"`
	Place  string    `json:"place"`
}

// Parcel represent parcel in delivery
type Parcel struct {
	Weight           float32 `json:"weight"`
	Nature           string  `json:"nature"`
	SenderFullName   string  `json:"senderFullName"`
	ReceiverFullName string  `json:"receiverFullName"`
	Origin           string  `json:"origin"`
	Destination      string  `json:"destination"`
}

// Tracking represent current state with all data about tracking historique of an order
type Tracking struct {
	OrderID int             `json:"orderId"`
	Events  []TrackingEvent `json:"events"`
	Parcel  Parcel          `json:"parcel"`
}

// EventTime hold event time and french formatted time string
type EventTime struct {
	RealTime  time.Time `json:"realTime"`
	Formatted string    `json:"formatted"`
}

// FormatTimeFR method set Formatted field of EventTime datatype
// french '03 Décembre 2019 à 09:15' like time format
func (e *EventTime) FormatTimeFR() {
	timeString := strings.Join(
		strings.Split(
			fmt.Sprintf(e.RealTime.Format("15:04:05")), ":",
		)[:2], ":",
	)

	var month string
	switch e.RealTime.Month().String() {
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
	e.Formatted = fmt.Sprintf(
		"%d %s, %d à %s",
		e.RealTime.Day(),
		month, e.RealTime.Year(),
		timeString,
	)
}
