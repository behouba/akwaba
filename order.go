package dsapi

import (
	"time"
)

// Order states id constants values
const (
	StateWaitingConfirmation = 1
	StateWaitingPickUp       = 2
	StateInProcessing        = 3
	StateCanceled            = 4
	StateFrozen              = 5
	StateTerminated          = 6
)

// Order struct represent order that will be created by users
type Order struct {
	ID              int       `json:"id,omitempty"`
	PaymentTypeID   int       `json:"paymentTypeId" binding:"required"`
	CustomerID      int       `json:"customerId" binding:"required"`
	CreatedAt       time.Time `json:"createdAt"`
	State           int       `json:"state"`
	TotalCost       float64   `json:"totalCost"`
	Description     string    `json:"description"  binding:"required"`
	PickUpAddressID int       `json:"pickupAddressId"  binding:"required"`
	Parcels         []Parcel  `json:"parcels" binding:"required"`
}

// ComputeCost return totalCost of the order
func (o *Order) ComputeCost() (cost float64) {
	for _, p := range o.Parcels {
		cost += p.ComputeCost(o.PickUpAddressID)
	}
	return
}

// Parcel struct is representation of parcel in system
type Parcel struct {
	ID                int     `json:"id,omitempty"`
	OrderID           int     `json:"orderId,omitempty"`
	Cost              float64 `json:"cost"`
	Weight            float64 `json:"weight" binding:"required"`
	Description       string  `json:"description" binding:"required"`
	StateID           int     `json:"stateId"`
	DeliveryAddressID int     `json:"deliveryAddressId" binding:"required"`
}

// ComputeCost compute the cost for a parcel and return the value
func (p *Parcel) ComputeCost(pickUpAddrID int) (cost float64) {
	// make request to fetch parcel transportation cost
	// should compute price base on origin area,
	// delivery area and the weight of the order

	cost = 2500 // mock value
	return
}

// MapPoint represent geolocation map address
type MapPoint struct {
	Longitude float64 `json:"longitude"`
	Latitude  float64 `json:"latitude"`
}

// Address represent delivery address provided by customers
type Address struct {
	ID          int      `json:"id,omitempty"`
	CustomerID  int      `json:"customer_id"`
	AreaID      int      `json:"areaId" binding:"required"`
	FullName    string   `json:"fullName" binding:"required"`
	Phone       string   `json:"phone" binding:"required"`
	Map         MapPoint `json:"map"`
	Description string   `json:"description" binding:"required"`
	Type        string   `json:"type" binding:"required"`
}

// Track represent an event in order journey
type Track struct {
	OrderID  int       `json:"orderId"`
	Time     time.Time `json:"time"`
	OfficeID int       `json:"officeId"`
	EventID  int       `json:"EventId"`
}

// ValidateData function help validate data into new order before creation
func (o *Order) ValidateData() (err error) {
	// make checks and verification here
	return
}
