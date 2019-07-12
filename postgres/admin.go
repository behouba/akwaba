package postgres

import (
	"encoding/json"
	"log"
	"time"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
	"golang.org/x/crypto/bcrypt"
)

//EmployeeStorageH Employee storage for head office
type EmployeeStorageH struct {
	db *sqlx.DB
}

type Shipment struct {
	ID            uint64                  `json:"id"`
	Sender        json.RawMessage         `json:"sender"`
	Recipient     json.RawMessage         `json:"recipient"`
	TimeAccepted  time.Time               `json:"timeAccepted"`
	TimeDelivered time.Time               `json:"timeDelivered"`
	OrderID       uint64                  `json:"orderId"`
	CategoryI     akwaba.ShipmentCategory `json:"category"`
	Cost          uint                    `json:"cost"`
	PaymentOption akwaba.PaymentOption    `json:"paymentOption"`
	Weight        float64                 `json:"weight"`
	Nature        string                  `json:"nature"`
}

func NewEmployeeStorageH(db *sqlx.DB) *EmployeeStorageH {
	return &EmployeeStorageH{db: db}
}

// Authenticate head office employee
func (es *EmployeeStorageH) Authenticate(emp *akwaba.Employee) (employee akwaba.Employee, err error) {
	var passwordHash string
	err = es.db.QueryRow(
		`SELECT 
		e.first_name, e.last_name, e.password, e.office_id, o.name
		FROM employees AS e
		LEFT JOIN offices AS o
		ON e.office_id = o.office_id
		WHERE login=$1 AND is_active=$2 AND position_id=$3`,
		emp.Login, true, akwaba.HeadOfficeManagerPositionID,
	).Scan(
		&employee.FirstName, &employee.LastName,
		&passwordHash, &employee.Office.ID,
		&employee.Office.Name,
	)
	if err != nil {
		return
	}
	err = bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(emp.Password))
	if err != nil {
		return
	}
	return
}

type AdminOrderStorage struct {
	db *sqlx.DB
	PricingStorage
}

func NewAdminOrderStorage(db *sqlx.DB) *AdminOrderStorage {
	return &AdminOrderStorage{db: db}
}

func (a *AdminOrderStorage) Pending() (orders []akwaba.Order, err error) {
	rows, err := a.db.Query(
		`SELECT
		o.order_id, o.time_created, o.sender_name, o.sender_phone, 
		o.sender_area_id, a1.name, o.sender_address, o.recipient_name, 
		o.recipient_phone, o.recipient_area_id, a2.name, o.recipient_address,
		o.shipment_category_id, sc.name, o.nature, o.payment_option_id, po.name, o.cost, o.distance,
		ost.order_state_id, ost.name
		FROM orders AS o
		LEFT JOIN order_states AS ost
		ON o.order_state_id = ost.order_state_id
		LEFT JOIN shipment_categories AS sc
		ON sc.shipment_category_id = o.shipment_category_id
		LEFT JOIN payment_options AS po
		ON po.payment_option_id = o.payment_option_id
		LEFT JOIN areas as a1
		ON a1.area_id = o.sender_area_id
		LEFT JOIN areas as a2
		ON a2.area_id = o.recipient_area_id
		WHERE o.order_state_id=$1 OR o.order_state_id=$2 ORDER BY o.time_created DESC`,
		akwaba.OrderStatePendingID, akwaba.OrderInProcessing,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order
		err = rows.Scan(
			&o.OrderID, &o.TimeCreated, &o.Sender.Name, &o.Sender.Phone,
			&o.Sender.Area.ID, &o.Sender.Area.Name,
			&o.Sender.Address, &o.Recipient.Name,
			&o.Recipient.Phone, &o.Recipient.Area.ID, &o.Recipient.Area.Name,
			&o.Recipient.Address, &o.Category.ID, &o.Category.Name,
			&o.Nature, &o.PaymentOption.ID, &o.PaymentOption.Name, &o.Cost, &o.Distance,
			&o.State.ID, &o.State.Name,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		orders = append(orders, o)
	}
	return
}

func (a *AdminOrderStorage) Cancel(orderID uint64) (err error) {
	return
}

func (a *AdminOrderStorage) Confirm(orderID uint64) (shipmentID uint64, err error) {
	var o akwaba.Order
	err = a.db.QueryRow(
		`SELECT 
		customer_id, order_state_id, sender_name, sender_phone,
		sender_area_id, sender_address, recipient_name, 
		recipient_phone, recipient_address, shipment_category_id, 
		nature, payment_option_id, cost, distance
		FROM orders WHERE order_id=$1`,
	).Scan(
		&o.CustomerID, &o.State.ID, &o.Sender.Name, &o.Sender.Phone,
		&o.Sender.Area.ID, &o.Sender.Address, &o.Recipient.Name,
		&o.Recipient.Phone, &o.Recipient.Address, &o.Category.ID, &o.Nature,
		&o.PaymentOption.ID, &o.Cost, &o.Distance,
	)
	if err != nil {
		return
	}
	shipmentID, err = a.saveShipment(&o)
	if err != nil {
		return
	}
	return
}

func (a *AdminOrderStorage) saveShipment(o *akwaba.Order) (shipmentID uint64, err error) {
	err = a.db.QueryRow(
		`INSERT INTO shipments
		(order_id, customer_id, sender_name, sender_phone, 
		sender_area_id, sender_address, recipient_name,
		recipient_phone, recipient_area_id, recipient_address, 
		shipment_category_id,cost, shipment_state_id, 
		nature, payment_option_id, distance) 
		VALUES 
		($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19)
		RETURNING shipment_id`,
		o.OrderID, o.CustomerID, o.Sender.Name, o.Sender.Phone, o.Sender.Area.ID,
		o.Sender.Address, o.Recipient.Name, o.Recipient.Phone, o.Recipient.Area.ID,
		o.Recipient.Address, o.Category.ID, o.Cost, akwaba.ShipmentPendingPickupID,
		o.Nature, o.PaymentOption.ID, o.Distance,
	).Scan(&shipmentID)
	return
}

func (a *AdminOrderStorage) Create(o *akwaba.Order) (err error) {
	return
}

/* offices database interractions */

//EmployeeStorageO Employee storage for offices
type EmployeeStorageO struct {
	db *sqlx.DB
}

func NewEmployeeStorageO(db *sqlx.DB) *EmployeeStorageO {
	return &EmployeeStorageO{db: db}
}

// Authenticate offices employees
func (es *EmployeeStorageO) Authenticate(emp *akwaba.Employee) (employee akwaba.Employee, err error) {
	var passwordHash string
	err = es.db.QueryRow(
		`SELECT 
		e.first_name, e.last_name, e.password, e.office_id, o.name
		FROM employees AS e
		LEFT JOIN offices AS o
		ON e.office_id = o.office_id
		WHERE login=$1 AND is_active=$2 AND position_id=$3`,
		emp.Login, true, akwaba.OfficesManagerPositionID,
	).Scan(
		&employee.FirstName, &employee.LastName,
		&passwordHash, &employee.Office.ID,
		&employee.Office.Name,
	)
	if err != nil {
		return
	}
	err = bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(emp.Password))
	if err != nil {
		return
	}
	return
}
