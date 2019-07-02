package akwaba

type CustomerMailer interface {
	WelcomeEmail(cust *Customer) error
	ResetPasswordEmail(cust *Customer, token string) error
	OrderCreationEmail(cust *Customer, order *Order) error
	OrderConfirmationEmail(cust *Customer, order *Order) error
	TrackingStatusEmail(cust *Customer) error
}
