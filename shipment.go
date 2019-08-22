package akwaba

import "time"

// Shipment state ids
const (
	ShipmentPendingPickupID      uint8 = 1 // "En attente de ramassage"
	ShipmentPickedUpID           uint8 = 2 // "Ramassé"
	ShipmentPickupFailedID       uint8 = 3 // "Échec de ramassage"
	ShipmentArrivedAtOfficeID    uint8 = 4 // "Arrivé à l'agence locale de distribution"
	ShipmentLeftOfficeID         uint8 = 5 // "Depart de l'agence locale de distribution"
	ShipmentDeliveredID          uint8 = 6 // "Livré"
	ShipmentDeliveryFailedID     uint8 = 7 // "Échec de livraison"
	ShipmentReturnedID           uint8 = 8 // "Retourné"
	ShipmentExceptionalFailureID uint8 = 9 // "Échec d'acheminement"
)

// Shipment represent parcel in delivery
type Shipment struct {
	ID            uint64        `json:"id"`
	UserID        uint          `json:"userId"`
	OrderID       uint64        `json:"orderId"`
	Weight        float64       `json:"weight"`
	State         ShipmentState `json:"state"`
	TimeCreated   time.Time     `json:"timeCreated"`
	TimeDelivered NullTime      `json:"timeDelivered"`
	OrderData
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
