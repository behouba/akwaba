package dsapi

import (
	"time"
)

// Order struct represent order that will be created by users
type Order struct {
	ID            int       `json:"id,omitempty"`
	PaymentType   int       `json:"paymentType"`
	CustomerID    int       `json:"customerId"`
	Cost          float64   `json:"cost"`
	CreatedAt     time.Time `json:"createdAt"`
	State         int       `json:"state"`
	Description   string    `json:"description"`
	PickUpAddress Address   `json:"pickup_address"`
	Parcels       []Parcel  `json:"parcels"`
}

// Parcel struct is representation of parcel in system
type Parcel struct {
	ID              int     `json:"id"`
	OrderID         int     `json:"orderId"`
	Weight          float64 `json:"weight"`
	Description     string  `json:"description"`
	StateID         int     `json:"stateId"`
	DeliveryAddress Address `json:"delivery_address"`
}

// MapPoint represent geolocation map address
type MapPoint struct {
	Longitude float64 `json:"longitude"`
	Latitude  float64 `json:"latitude"`
}

// Address represent delivery address provided by customers
type Address struct {
	ID           int      `json:"id"`
	TownID       int      `json:"townId"`
	ReceiverName string   `json:"receiverName"`
	Phone        string   `json:"phone"`
	Map          MapPoint `json:"map"`
	Description  string   `json:"description"`
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
