package dsapi

import "time"

// Order struct represent order that will be created by users
type Order struct {
	ID                int       `json:"id"`
	PaymentTypeID     int       `json:"paymentTypeId"`
	CustomerID        int       `json:"customerId"`
	ProductCategoryID int       `json:"productCategoryId"`
	Weight            float64   `json:"weight"`
	Cost              int       `json:"cost"`
	CreatedAt         time.Time `json:"createdAt"`
	Description       string    `json:"description"`
	PackingID         int       `json:"packingId"`
	OriginAddress     Address   `json:"origin_address"`
	DeliveryAddress   Address   `json:"delivery_address"`
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
type OrderTrace struct {
	Order  Order   `json:"order"`
	Events []Event `json:"events"`
}

// Event represent an event in order way
type Event struct {
	Title      string    `json:"title"`
	DateTime   time.Time `json:"dateTime"`
	LocationID int       `json:"locationId"`
	TowID      int       `json:"townId"`
}

// ValidateData function help validate data into new order before creation
func (o *Order) ValidateData() (err error) {
	// make checks and verification here
	return
}
