package akwaba

import (
	"context"
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
	// TrackShipment retreive tracking for the given shipmentID or orderID
	// if id is not the shipmentID will be treated as orderID
	TrackShipment(ctx context.Context, ID uint64) (tracking Tracking, err error)
	// TrackByOrderID(ctx context.Context, orderID uint64) (tracking Tracking, err error)
}

// FormatTimeFR method set Formatted field of EventTime datatype
// french '03 Décembre 2019 à 09:15' like time format
func (s *Shipment) FormatTimeFR() (formatted string) {
	timeString := strings.Join(
		strings.Split(
			fmt.Sprintf(s.TimeCreated.Format("15:04:05")), ":",
		)[:2], ":",
	)

	formatted = fmt.Sprintf(
		"%d %s, %d à %s",
		s.TimeCreated.Day(),
		s.TimeCreated.Month(),
		s.TimeCreated.Year(),
		timeString,
	)
	return
}
