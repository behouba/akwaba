package akwaba

// Positions ids
const (
	HeadOfficeManagerPositionID uint8 = 1
	OfficesManagerPositionID    uint8 = 2
	CourierPositionID           uint8 = 3
)

// Employee represent an employee with it identifiers
type Employee struct {
	ID         uint   `json:"id"`
	FirstName  string `json:"firstName"`
	LastName   string `json:"lastName"`
	Phone      string `json:"phone"`
	Email      string `json:"email"`
	Login      string `json:"login"`
	Password   string `json:"password"`
	Office     Office `json:"office"`
	PositionID uint8  `json:"positionId"`
}

type EmployeeAuthentifier interface {
	Authenticate(e *Employee, ip string) (empl Employee, err error)
}

// Office represent office data
type Office struct {
	ID   uint   `json:"id"`
	Name string `json:"name"`
	City City   `json:"city"`
	Area Area   `json:"area"`
}
