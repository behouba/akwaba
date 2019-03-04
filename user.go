package dsapi

// User is representation of new customer
// registration's data
type User struct {
	FirstName string  `json:"firstName"`
	LastName  string  `json:"lastName"`
	TownID    int     `json:"townId"`
	Phone     string  `json:"phone"`
	Email     string  `json:"email"`
	PostionX  float32 `json:"positionX"`
	PostionY  float32 `json:"positionY"`
}
