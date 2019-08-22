package akwaba

// MailerBaseURL constant value of mailing server address on host machine
const MailerBaseURL = "http://127.0.0.1:8082/v0"

type MailingDataStorage interface {
	FromOrderID(orderID uint64) (userName, userEmail string, err error)
	FromShipmentID(shipmentID uint64) (userName, userEmail string, err error)
	FromEmail(email string) (userName string, err error)
}
