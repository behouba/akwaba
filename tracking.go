package dsapi

// Differents order types identifier constants
const (
	OrderTypeOnline   = 1
	OrderTypeOnCall   = 2
	OrderTypeInOffice = 3
)

// Payement types identifier
const (
	PaymentBySender   = 1
	PaymentByReceiver = 2
)

// Events identifier constants
const (
	EventConfirmation       = 1
	EventPickedUp           = 2
	EventLeftOrigin         = 3
	EventAtTransitOffice    = 4
	EventLeftTransitOffice  = 5
	EventAtDeliveryOffice   = 6
	EventLeftDeliveryOffice = 7
	EventDelivered          = 8
	EventUserCancelation    = 9
	EventAdminCancelation   = 10
)
