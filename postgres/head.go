package postgres

import (
	"errors"
	"log"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
	"golang.org/x/crypto/bcrypt"
)

//HeadManagerStorage Employee storage for head office
type HeadManagerStorage struct {
	db *sqlx.DB
}

func NewHeadManagerStorage(db *sqlx.DB) *HeadManagerStorage {
	return &HeadManagerStorage{db: db}
}

// Authenticate head office employee
func (es *HeadManagerStorage) Authenticate(emp *akwaba.Employee) (employee akwaba.Employee, err error) {
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

type OrdersManagementStore struct {
	db *sqlx.DB
	PricingStorage
	OrderStore
}

func NewOrdersManagementStore(db *sqlx.DB, mapApiKey string) *OrdersManagementStore {
	a := OrdersManagementStore{db: db}
	a.PricingStorage.db, a.OrderStore.db, a.PricingStorage.apiKey = db, db, mapApiKey
	return &a
}

func (a *OrdersManagementStore) ActiveOrders() (orders []akwaba.Order, err error) {
	rows, err := a.db.Query(
		`select * from full_orders
		WHERE order_state_id=$1 OR order_state_id=$2 
		ORDER BY time_created DESC`,
		akwaba.OrderStatePendingID, akwaba.OrderInProcessing,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order
		err = rows.Scan(
			&o.OrderID, &o.ShipmentID, &o.CustomerID, &o.TimeCreated, &o.TimeClosed,
			&o.Sender.Name, &o.Sender.Phone, &o.Sender.Area.ID, &o.Sender.Area.Name,
			&o.Sender.Address, &o.Recipient.Name, &o.Recipient.Phone, &o.Recipient.Area.ID,
			&o.Recipient.Area.Name, &o.Recipient.Address, &o.Category.ID, &o.Category.Name,
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

func (a *OrdersManagementStore) ClosedOrders(date string) (orders []akwaba.Order, err error) {
	rows, err := a.db.Query(
		`select * from closed_orders
		WHERE time_closed::date = date($1) ORDER BY time_created DESC`,
		date,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order
		err = rows.Scan(
			&o.OrderID, &o.CustomerID, &o.TimeCreated, &o.TimeClosed,
			&o.Sender.Name, &o.Sender.Phone, &o.Sender.Area.ID, &o.Sender.Area.Name,
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

func (a *OrdersManagementStore) Save(o *akwaba.Order) (err error) {
	err = a.setAreaID(o.Sender.Area.Name, &o.Sender.Area.ID)
	if err != nil {
		return
	}
	err = a.setAreaID(o.Recipient.Area.Name, &o.Recipient.Area.ID)
	if err != nil {
		return
	}
	o.Cost, o.Distance, err = a.Cost(o.Sender.Area.Name, o.Recipient.Area.Name, o.Category.ID)
	if err != nil {
		return
	}

	err = a.db.QueryRow(
		`INSERT
		INTO orders 
		(sender_name, sender_phone, 
		sender_area_id, sender_address, recipient_name, 
		recipient_phone, recipient_area_id, recipient_address, 
		shipment_category_id, nature, payment_option_id, cost, distance, order_state_id)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) RETURNING order_id`,
		o.Sender.Name, o.Sender.Phone, o.Sender.Area.ID, o.Sender.Address,
		o.Recipient.Name, o.Recipient.Phone, o.Recipient.Area.ID, o.Recipient.Address,
		o.Category.ID, o.Nature, o.PaymentOption.ID, o.Cost, o.Distance, akwaba.OrderStatePendingID,
	).Scan(&o.OrderID)
	if err != nil {
		return
	}
	return
}

func (o *OrdersManagementStore) Cancel(orderID uint64) (err error) {
	var shipmentID uint64
	var shipmentStateID uint8
	err = o.db.QueryRow(
		`SELECT shipment_id, shipment_state_id FROM shipments WHERE order_id=$1`,
		orderID,
	).Scan(&shipmentID, &shipmentStateID)
	if err != nil {
		return
	}

	if shipmentID > 0 &&
		shipmentStateID != akwaba.ShipmentReturnedID &&
		shipmentStateID != akwaba.ShipmentPendingPickupID {
		return errors.New("Impossible d'annuler cette commande, livraison en cours")
	}
	_, err = o.db.Exec(
		`UPDATE orders SET order_state_id=$1, time_closed=NOW() WHERE order_id=$2`,
		akwaba.OrderStateCanceledID, orderID,
	)
	if err != nil {
		return
	}
	return
}

func (a *OrdersManagementStore) Confirm(orderID uint64) (shipmentID uint64, err error) {
	var orderStateID uint8
	err = a.db.QueryRow(
		`SELECT order_state_id 
		FROM orders 
		WHERE order_id=$1`,
		orderID,
	).Scan(&orderStateID)
	if err != nil {
		return
	}
	if orderStateID != akwaba.OrderStatePendingID {
		return 0, errors.New(
			"Désolé, impossible de confirmer cette commande. Merci de verifier le status actuel de la commande",
		)
	}

	// shipmentID, err = a.saveShipment(&o)
	// if err != nil {
	// 	return
	// }

	return
}

func (a *OrdersManagementStore) CreateShipment(orderID uint64) (shipmentID uint64, err error) {
	var o akwaba.Order

	// retreiving order data from orders table
	err = a.db.QueryRow(
		`SELECT
			order_id, customer_id, sender_name, sender_phone,
			sender_area_id, sender_address, recipient_name,
			recipient_phone, recipient_area_id, recipient_address, shipment_category_id,
			nature, payment_option_id, cost, distance
		FROM orders WHERE order_id=$1`,
		orderID,
	).Scan(
		&o.OrderID, &o.CustomerID, &o.Sender.Name, &o.Sender.Phone,
		&o.Sender.Area.ID, &o.Sender.Address, &o.Recipient.Name,
		&o.Recipient.Phone, &o.Recipient.Area.ID, &o.Recipient.Address, &o.Category.ID, &o.Nature,
		&o.PaymentOption.ID, &o.Cost, &o.Distance,
	)
	if err != nil {
		return
	}

	const shipmentStateID = akwaba.ShipmentPendingPickupID
	// inserting order data in shipment table
	err = a.db.QueryRow(
		`INSERT INTO shipments
		(order_id, customer_id, sender_name, sender_phone, 
		sender_area_id, sender_address, recipient_name,
		recipient_phone, recipient_area_id, recipient_address, 
		shipment_category_id,cost, 
		nature, payment_option_id, distance, shipment_state_id) 
		VALUES 
		($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
		RETURNING shipment_id`,
		o.OrderID, o.CustomerID, o.Sender.Name, o.Sender.Phone, o.Sender.Area.ID,
		o.Sender.Address, o.Recipient.Name, o.Recipient.Phone, o.Recipient.Area.ID,
		o.Recipient.Address, o.Category.ID, o.Cost,
		o.Nature, o.PaymentOption.ID, o.Distance, shipmentStateID,
	).Scan(&shipmentID)
	if err != nil {
		return
	}

	_, err = a.db.Exec(
		`INSERT INTO shipments_history 
		(shipment_id, shipment_state_id, area_id) VALUES ($1, $2, $3)`,
		shipmentID, shipmentStateID, o.Sender.Area.ID,
	)

	return
}

func (o *OrdersManagementStore) UpdateState(orderID uint64, stateID uint8) (err error) {
	_, err = o.db.Exec(
		`UPDATE orders SET order_state_id=$1 WHERE order_id=$2`,
		stateID, orderID,
	)
	if err != nil {
		return
	}
	_, err = o.db.Exec(
		`INSERT INTO 
		orders_history (order_id, order_state_id)
		VALUES ($1, $2)`,
		orderID,
		stateID,
	)
	return
}

func (a *OrdersManagementStore) addPendingTracking(shipmentID uint64, areaID uint) (err error) {
	_, err = a.db.Exec(
		`INSERT INTO trackings (shipment_id, shipment_state_id, area_id) VALUES ($1, $2, $3);`,
		shipmentID, akwaba.ShipmentPendingPickupID, areaID,
	)
	return
}

type CustomerStorage struct {
	db *sqlx.DB
}

func NewCustomerStorage(db *sqlx.DB) *CustomerStorage {
	return &CustomerStorage{db: db}
}

func (a *CustomerStorage) Customers() (customers []akwaba.Customer) {
	rows, err := a.db.Query(
		`SELECT 
		customer_id, full_name, phone, email, 
		password, account_type_id, is_email_verified, 
		is_phone_verified, address 
		FROM customers LIMIT 500`,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var c akwaba.Customer
		err = rows.Scan(
			&c.ID, &c.FullName, &c.Phone, &c.Email, &c.Password,
			&c.AccountTypeID, &c.IsEmailVerified,
			&c.IsPhoneVerified, &c.Address,
		)
		if err != nil {
			return
		}
		customers = append(customers, c)
	}
	return
}

// type OrderStateStore struct {
// 	db *sqlx.DB
// }

// func NewOrderStateStore(db *sqlx.DB) *OrderStateStore {
// 	return &OrderStateStore{db: db}
// }

// func (o *OrderStateStore) UpdateState(orderID uint64, stateID uint8) (err error) {

// 	return
// }

type ShipmentStateStore struct {
	db *sqlx.DB
}

func NewShipmentStateStore(db *sqlx.DB) *ShipmentStateStore {
	return &ShipmentStateStore{db: db}
}

func (s *ShipmentStateStore) UpdateState(shipmentID uint64, stateID uint8, areaID uint) (err error) {
	_, err = s.db.Exec(
		`UPDATE shipments SET shipment_state_id=$1 WHERE shipment_id=$2`,
		stateID, shipmentID,
	)
	if err != nil {
		return
	}
	_, err = s.db.Exec(
		`INSERT INTO shipments_history 
		(shipment_id, shipment_state_id, area_id) 
		VALUES ($1, $2, $3)`,
		shipmentID, stateID, areaID,
	)
	if err != nil {
		return
	}
	return
}
