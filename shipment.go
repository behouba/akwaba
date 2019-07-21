package akwaba

import "time"

// Shipment state ids
const (
	ShipmentPendingPickupID      uint8 = 1 // "En attente de ramassage"
	ShipmentPickedUpID           uint8 = 2 // "Ramassé"
	ShipmentPickupFailedID       uint8 = 3 // "Échec de ramassage"
	ShipmentLeftOfficeID         uint8 = 4 // "Arrivé à l'agence locale de distribution"
	ShipmentArrivedAtOfficeID    uint8 = 5 // "Depart de l'agence locale de distribution"
	ShipmentDeliveredID          uint8 = 6 // "Livré"
	ShipmentDeliveryFailedID     uint8 = 7 // "Échec de livraison"
	ShipmentReturnedID           uint8 = 8 // "Retourné"
	ShipmentExceptionalFailureID uint8 = 9 // "Échec d'acheminement"
)

// Shipment represent parcel in delivery
type Shipment struct {
	ID            uint64           `json:"id"`
	CustomerID    uint             `json:"customerId"`
	Sender        Address          `json:"sender"`
	Recipient     Address          `json:"recipient"`
	TimeCreated   time.Time        `json:"timeCreated"`
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

// Address of pickups or delivery
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

type ShipmentManager interface {
	Pickups(office *Office) (shipments []Shipment, err error)
	PickedUp(office *Office, shipmentID uint64, weight float64) (err error)
	UpdateState(shipmentID uint64, stateID uint8, areaID uint) (err error)
	Stock(office *Office) (shipments []Shipment, err error)
	CheckIn(office *Office, shipmentID uint64) (err error)
	CheckOut(office *Office, shipmentID uint64) (err error)
	Deliveries(office *Office) (shipments []Shipment, err error)
	Delivered(office *Office, shipmentID uint64) (err error)
	DeliveryFailed(office *Office, shipmentID uint64) (err error)
}
