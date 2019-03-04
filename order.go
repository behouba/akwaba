package dsapi

import "time"

type Order struct {
	ID                int
	PaymentTypeID     int
	CustomerID        int
	ProductCategoryID int
	Weight            float64
	Cost              int
	CreatedAt         time.Time
	Description       string
	PackingID         int
	Address           Address
}

type MapPoint struct {
	Longitude float64
	Latitude  float64
}
type Address struct {
	ID           int
	TownID       int
	ReceiverName string
	Phone        string
	Map          MapPoint
	Description  string
}
