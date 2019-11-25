package akwaba

import "context"

// shipment category ids
const (
	DocumentCateogryId uint8 = 1
	ParcelCategoryId   uint8 = 2
)

// PricingService interface for shipment cost calculation
type PricingService interface {
	FindAreas(ctx context.Context, query string) (areas []Area)
	Pricing(ctx context.Context, from, to string) (pricing Pricing, err error)
	Cost(ctx context.Context, categoryID uint8, from, to string) (cost uint, distance float64, err error)
	PaymentOptions() (poMap map[uint8]string, po []PaymentOption, err error)
	ShipmentCategories() (catMap map[uint8]string, cats []ShipmentCategory, err error)
}

// Pricing data type
type Pricing struct {
	Distance     float64 `json:"distance"`
	ParcelCost   uint    `json:"parcelCost"`
	DocumentCost uint    `json:"documentCost"`
}
