package akwaba

import (
	"fmt"
	"strings"
	"time"

	"github.com/speps/go-hashids"
)

const (
	trackIDSalt    = "akwabaexpress"
	trackIDCharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
)

func hashIDs() (*hashids.HashID, error) {
	hd := hashids.NewData()
	hd.Salt = trackIDSalt
	hd.Alphabet = trackIDCharSet
	hd.MinLength = 10
	return hashids.NewWithData(hd)
}

func EncodeParcelID(id int) (trackID string, err error) {
	h, err := hashIDs()
	if err != nil {
		return
	}
	trackID, err = h.Encode([]int{id})
	if err != nil {
		return
	}
	return
}

func DecodeTrackID(trackID string) (parcelID int, err error) {
	h, err := hashIDs()
	if err != nil {
		return
	}
	v, err := h.DecodeWithError(trackID)
	if err != nil {
		return
	}
	parcelID = v[0]
	return
}

// Parcel represent parcel in delivery
type Parcel struct {
	ParcelID int    `json:"parcelId"`
	TrackID  string `json:"trackId"`
	Order
}

// Tracking represent current state with all data about tracking historique of an order
type Tracking struct {
	TrackID string  `json:"trackId"`
	Events  []Event `json:"events"`
	Parcel  Parcel  `json:"parcel"`
}

// EventTime hold event time and french formatted time string
type EventTime struct {
	RealTime  time.Time `json:"realTime"`
	Formatted string    `json:"formatted"`
}

// Event represent an event in parcel tracking journey
type Event struct {
	ID    int       `json:"id"`
	Title string    `json:"title"`
	Time  EventTime `json:"time"`
	City  City      `json:"city"`
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
