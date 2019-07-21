package akwaba

type KeyVal map[uint8]string

type SystemData interface {
	Areas() []Area
	PaymentOptions() []PaymentOption
	ShipmentCategories() []ShipmentCategory
}
