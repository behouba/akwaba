package akwaba

// Parcel state id values
var (
	ParcelWaitingPickup  = ParcelState{ID: 1}
	ParcelOnTheWay       = ParcelState{ID: 2}
	ParcelOutForDelivery = ParcelState{ID: 3}
	ParcelDelivered      = ParcelState{ID: 4}
	ParcelFailedDelivery = ParcelState{ID: 5}
	ParcelReturned       = ParcelState{ID: 6}
)

type ParcelState struct {
	ID   int8   `json:"id"`
	Name string `json:"name"`
}

// Parcel represent parcel in delivery
type Parcel struct {
	ParcelID int     `json:"parcelId"`
	TrackID  string  `json:"trackId"`
	Weight   float64 `json:"weight"`
	Order
}
