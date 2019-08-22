package akwaba

// shipment category ids
const (
	DocumentCateogryId uint8 = 1
	ParcelCategoryId   uint8 = 2
)

// PricingService interface for shipment cost calculation
type PricingService interface {
	FindArea(query string) (areas []Area)
	Pricing(from, to string) (pricing Pricing, err error)
	Cost(from, to string, categoryID uint8) (cost uint, distance float64, err error)
}

// Pricing data type
type Pricing struct {
	Distance     float64 `json:"distance"`
	ParcelCost   uint    `json:"parcelCost"`
	DocumentCost uint    `json:"documentCost"`
}
