package akwaba

import "time"

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
	ID            uint64           `json:"id"`
	Sender        Address          `json:"sender"`
	Recipient     Address          `json:"recipient"`
	TimeAccepted  time.Time        `json:"timeAccepted"`
	TimeDelivered time.Time        `json:"timeDelivered"`
	OrderID       uint64           `json:"orderId"`
	PickupCity    City             `json:"pickupCity"`
	DeliveryCity  City             `json:"deliveryCity"`
	Category      ShipmentCategory `json:"category"`
	Cost          uint             `json:"cost"`
	PaymentOption PaymentOption    `json:"paymentOption"`
	Weight        float64          `json:"weight"`
	Nature        string           `json:"nature"`
}

// ShipmentCategory represent shipment category
type ShipmentCategory struct {
	ID      uint8  `json:"id"`
	Name    string `json:"name"`
	MinCost uint   `json:"minCost"`
	MaxCost uint   `json:"maxCost"`
}

// Address of pickup or delivery
type Address struct {
	ContactName string `json:"contactName"`
	Phone       string `json:"phone"`
	GooglePlace string `json:"googlePlace"`
	Description string `json:"description"`
}

type ShipmentCalculator interface {
	Cost(from, to string, categoryID uint8) (cost uint, distance float64, err error)
}
