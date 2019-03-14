package dsapi

import (
	"time"
)

// Order struct represent order that will be created by users
type Order struct {
	ID              int       `json:"id"`
	PaymentType     int       `json:"paymentType"`
	Customer        User      `json:"customer"`
	Weight          float64   `json:"weight"`
	Cost            int       `json:"cost"`
	CreatedAt       time.Time `json:"createdAt"`
	CurrentState    int       `json:"currentState"`
	Description     string    `json:"description"`
	PackingID       int       `json:"packingId"`
	OriginAddress   Address   `json:"origin_address"`
	DeliveryAddress Address   `json:"delivery_address"`
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

// OrderTrace represent current updated tracking information about an order
// type OrderTrace struct {
// 	Order  Order   `json:"order"`
// 	Events []Event `json:"events"`
// }

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
