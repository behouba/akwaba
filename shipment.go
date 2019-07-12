package akwaba

import "time"

// Shipment state ids
const (
	ShipmentPendingPickupID         uint8 = 1  // "PENDING_PICKUP"
	ShipmentPickedUpID              uint8 = 2  // "PICKED_UP"
	ShipmentPickupFailedID          uint8 = 3  // "PICKED_UP_FAILED"
	ShipmentLeftOriginID            uint8 = 4  // "LEFT_ORIGIN_PLACE"
	ShipmentArrivedAtTransitPlaceID uint8 = 5  // "ARRIVED_AT_TRANSIT_PLACE"
	ShipmentLeftTransitPlaceID      uint8 = 6  // "LEFT_TRANSIT_PLACE"
	ShipmentArrivedAtDeliveryID     uint8 = 7  // "ARRIVED_AT_DELIVERY_PLACE"
	ShipmentDeliveredID             uint8 = 8  // "DELIVERED"
	ShipmentDeliveryFailedID        uint8 = 9  // "DELIVERY_FAILED"
	ShipmentReturnedID              uint8 = 10 // "RETURNED"
	ShipmentExceptionalFailureID    uint8 = 11 // "EXCEPTIONAL_FAILURE"
)

// Shipment represent parcel in delivery
type Shipment struct {
	ID            uint64           `json:"id"`
	CustomerID    uint             `json:"customerId"`
	Sender        Address          `json:"sender"`
	Recipient     Address          `json:"recipient"`
	TimeAccepted  time.Time        `json:"timeAccepted"`
	TimeDelivered time.Time        `json:"timeDelivered"`
	OrderID       uint64           `json:"orderId"`
	Category      ShipmentCategory `json:"category"`
	Cost          uint             `json:"cost"`
	State         ShipmentState    `json:"state"`
	PaymentOption PaymentOption    `json:"paymentOption"`
	Distance      float64          `json:"distance"`
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

// ShipmentState represent the current state of a shipment
type ShipmentState struct {
	ID   uint   `json:"id"`
	Name string `json:"name"`
}

// Address of pickup or delivery
type Address struct {
	Name    string `json:"name"`
	Area    Area   `json:"area"`
	Phone   string `json:"phone"`
	Address string `json:"address"`
}

// Area is a part of a given city
type Area struct {
	ID     uint   `json:"id"`
	Name   string `json:"name"`
	CityID uint   `json:"cityId"`
}

// PricingService interface for shipment cost calculation
type PricingService interface {
	FindArea(query string) (areas []Area)
	Cost(from, to string, categoryID uint8) (cost uint, distance float64, err error)
}
