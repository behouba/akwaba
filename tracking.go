package akwaba

import (
	"fmt"
	"strings"
	"time"
)

// Tracking events type
var (
// EventPickedUp               = Event{ID: 1, Title: "Colis récupéré par le coursier"}
// EventArrivedAtOriginOffice  = Event{ID: 2, Title: "Arrivé à l'agence de la zone d'expédition"}
// EventLeftOriginOffice       = Event{ID: 3, Title: "Départ de l'agence de zone d'expédition"}
// EventArrivedAtTransitOffice = Event{ID: 4, Title: "Arrivé dans une agence de transit"}
// EventLeftTransitOffice      = Event{ID: 5, Title: "Départ de l'agence de transit"}
// EventArrivedAtDestination   = Event{ID: 6, Title: "Arrivé à l'agence de la zone de destination"}
// EventDelivered              = Event{ID: 7, Title: "Le colis a été livré"}
// EventFailedDelivery         = Event{ID: 8, Title: "La livraison a échoué"}
// EventParcelReturned         = Event{ID: 9, Title: "Colis retourné"}
)

// Event represent most commom a tracking event
type Event struct {
	ID     int8       `json:"id"`
	Title  string     `json:"title"`
	Time   CustomTime `json:"time"`
	Office Office     `json:"office"`
}

const (
	trackIDSalt    = "akwabaexpress"
	trackIDCharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
)

// Tracking represent current state with all data about tracking historique of an order
type Tracking struct {
	TrackID  string  `json:"trackId"`
	Sender   Address `json:"sender"`
	Receiver Address `json:"receiver"`
	Weight   float64 `json:"weight"`
	Nature   string  `json:"nature"`
	History  []Event `json:"history"`
}

// CustomTime hold event time and french formatted time string
type CustomTime struct {
	Time      time.Time `json:"time"`
	Formatted string    `json:"formatted"`
}

// FormatTimeFR method set Formatted field of EventTime datatype
// french '03 Décembre 2019 à 09:15' like time format
func (s *Shipment) FormatTimeFR() (formatted string) {
	timeString := strings.Join(
		strings.Split(
			fmt.Sprintf(s.TimeAccepted.Format("15:04:05")), ":",
		)[:2], ":",
	)
	// var month string
	// switch e.RealTime.Month().String() {
	// case "January":
	// 	month = "Janvier"
	// case "February":
	// 	month = "Février"
	// case "March":
	// 	month = "Mars"
	// case "April":
	// 	month = "Avril"
	// case "May":
	// 	month = "Mai"
	// case "June":
	// 	month = "Juin"
	// case "July":
	// 	month = "Juillet"
	// case "August":
	// 	month = "Août"
	// case "September":
	// 	month = "Septembre"
	// case "October":
	// 	month = "Octobre"
	// case "November":
	// 	month = "Novembre"
	// case "December":
	// 	month = "Décembre"
	// }
	formatted = fmt.Sprintf(
		"%d %s, %d à %s",
		s.TimeAccepted.Day(),
		s.TimeAccepted.Month(), s.TimeAccepted.Year(),
		timeString,
	)
	return
}
