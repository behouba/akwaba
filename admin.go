package dsapi

// Employee represent an employee with it identifiers
type Employee struct {
	ID         int `json:"id"`
	OfficeID   int `json:"officeId"`
	PositionID int `json:"positionId"`
}

// EmployeeAuthData represent employee authentication data
type EmployeeAuthData struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}
