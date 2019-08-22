package akwaba

import (
	"fmt"
	"strings"
	"time"
)

// Event represent most commom a tracking event
type Event struct {
	Title string     `json:"title"`
	Time  *time.Time `json:"time"`
	City  string     `json:"city"`
	Area  string     `json:"area"`
}

// Tracking represent current state with all data about tracking historique of an order
type Tracking struct {
	Shipment Shipment `json:"shipment"`
	Events   []Event  `json:"events"`
}

// Tracker interface define shipment tracking method Track
type Tracker interface {
	TrackByShipmentID(shipmentID uint64) (tracking Tracking, err error)
	TrackByOrderID(orderID uint64) (tracking Tracking, err error)
}

// FormatTimeFR method set Formatted field of EventTime datatype
// french '03 Décembre 2019 à 09:15' like time format
func (s *Shipment) FormatTimeFR() (formatted string) {
	timeString := strings.Join(
		strings.Split(
			fmt.Sprintf(s.TimeCreated.Format("15:04:05")), ":",
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
		s.TimeCreated.Day(),
		s.TimeCreated.Month(), s.TimeCreated.Year(),
		timeString,
	)
	return
}
