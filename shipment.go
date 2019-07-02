package akwaba

import (
	"encoding/json"
	"time"
)

// Parcel state id values
var (
// ParcelWaitingPickup  = ParcelState{ID: 1}
// ParcelOnTheWay       = ParcelState{ID: 2}
// ParcelOutForDelivery = ParcelState{ID: 3}
// ParcelDelivered      = ParcelState{ID: 4}
// ParcelFailedDelivery = ParcelState{ID: 5}
// ParcelReturned       = ParcelState{ID: 6}
)

// Shipment represent parcel in delivery
type Shipment struct {
	ID            uint64
	Sender        *json.RawMessage
	Recipient     *json.RawMessage
	TimeAccepted  time.Time
	TimeDelivered time.Time
	OrderID       uint64
	PickupCityID  City
	DeliveryCity  City
	Category      ShipmentCategory
	Weight        float64
}
