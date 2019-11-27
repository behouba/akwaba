package akwaba

import "context"

// MailerBaseURL constant value of mailing server address on host machine
const MailerBaseURL = "http://127.0.0.1:8082/v0"

// MailingStorage interface define method to retreive customer info to send transaction email
type MailingStorage interface {
	FromOrderID(ctx context.Context, orderID uint64) (userName, userEmail string, err error)
	FromShipmentID(ctx context.Context, shipmentID uint64) (userName, userEmail string, err error)
	FromEmail(ctx context.Context, email string) (userName string, err error)
}
