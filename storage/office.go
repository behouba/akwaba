package postgres

import (
	"github.com/jmoiron/sqlx"
)

type ShipmentStorage struct {
	db *sqlx.DB
}

func NewShipmentStorage(db *sqlx.DB) *ShipmentStorage {
	return &ShipmentStorage{db: db}
}

// func (s *ShipmentStorage) Pickups(office *akwaba.Office) (shipments []akwaba.Shipment, err error) {
// 	// 	shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id,  sender_area,
// 	// sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_area, recipient_address,
// 	// time_created, time_delivered, shipment_category_id, shipment_category, cost, shipment_state_id, shipment_state,
// 	// weight, payment_option_id, distance, nature, current_office_id, pickup_office_id, delivery_office_id,
// 	rows, err := s.db.Query(
// 		`SELECT
// 			shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id,
// 			sender_area, sender_address, recipient_name, recipient_phone, recipient_area_id,
// 			recipient_area, recipient_address, time_created, shipment_category_id,
// 			shipment_category, cost, shipment_state_id, shipment_state, payment_option_id,
// 			payment_option, distance, nature
// 		 FROM full_shipments
// 		WHERE pickup_office_id=$1 AND shipment_state_id=$2;`,
// 		office.ID, akwaba.ShipmentPendingPickupID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	for rows.Next() {
// 		var s akwaba.Shipment
// 		// scan order

// 		err = rows.Scan(
// 			&s.ID, &s.OrderID, &s.UserID, &s.Sender.Name, &s.Sender.Phone,
// 			&s.Sender.Area.ID, &s.Sender.Area.Name, &s.Sender.Address, &s.Recipient.Name,
// 			&s.Recipient.Phone, &s.Recipient.Area.ID, &s.Recipient.Area.Name, &s.Recipient.Address,
// 			&s.TimeCreated, &s.Category.ID, &s.Category.Name, &s.Cost, &s.State.ID, &s.State.Name,
// 			&s.PaymentOption.ID, &s.PaymentOption.Name, &s.Distance, &s.Nature,
// 		)
// 		if err != nil {
// 			return
// 		}
// 		shipments = append(shipments, s)
// 	}
// 	return
// }

// func (s *ShipmentStorage) PickedUp(office *akwaba.Office, shipmentID uint64, weight float64) (err error) {
// 	_, err = s.db.Exec(
// 		`UPDATE shipments SET weight=$1, shipment_state_id=$2, current_office_id=$3 WHERE shipment_id=$4`,
// 		weight, akwaba.ShipmentPickedUpID, office.ID, shipmentID,
// 	)
// 	if err != nil {
// 		log.Println(err)
// 		return
// 	}
// 	return
// }

// func (s *ShipmentStorage) UpdateState(shipmentID uint64, stateID uint8, areaID uint) (err error) {
// 	// set delivery time if updating state to shipment delivered state
// 	_, err = s.db.Exec(
// 		`INSERT INTO shipments_history (shipment_id, shipment_state_id, area_id) VALUES ($1, $2, $3)`,
// 		shipmentID, stateID, areaID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	return
// }

// func (s *ShipmentStorage) Stock(office *akwaba.Office) (shipments []akwaba.Shipment, err error) {
// 	rows, err := s.db.Query(
// 		`SELECT
// 			shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id,
// 			sender_area, sender_address, recipient_name, recipient_phone, recipient_area_id,
// 			recipient_area, recipient_address, time_created, shipment_category_id,
// 			shipment_category, cost, shipment_state_id, shipment_state, weight, payment_option_id,
// 			payment_option, distance, nature
// 		 FROM full_shipments
// 		WHERE current_office_id=$1`,
// 		office.ID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	for rows.Next() {
// 		var s akwaba.Shipment
// 		// scan order

// 		err = rows.Scan(
// 			&s.ID, &s.OrderID, &s.UserID, &s.Sender.Name, &s.Sender.Phone,
// 			&s.Sender.Area.ID, &s.Sender.Area.Name, &s.Sender.Address, &s.Recipient.Name,
// 			&s.Recipient.Phone, &s.Recipient.Area.ID, &s.Recipient.Area.Name, &s.Recipient.Address,
// 			&s.TimeCreated, &s.Category.ID, &s.Category.Name, &s.Cost, &s.State.ID, &s.State.Name,
// 			&s.Weight, &s.PaymentOption.ID, &s.PaymentOption.Name, &s.Distance, &s.Nature,
// 		)
// 		if err != nil {
// 			return
// 		}
// 		shipments = append(shipments, s)
// 	}
// 	return
// }

// func (s *ShipmentStorage) CheckIn(office *akwaba.Office, shipmentID uint64) (err error) {
// 	var currentOfficeID sql.NullInt64
// 	var currentStateID uint8
// 	err = s.db.QueryRow(
// 		`SELECT
// 		current_office_id, shipment_state_id
// 		FROM shipments
// 		WHERE shipment_id=$1`,
// 		shipmentID,
// 	).Scan(&currentOfficeID, &currentStateID)
// 	if err != nil {
// 		if err.Error() == "sql: no rows in result set" {
// 			err = errors.New("Aucun colis trouvé")
// 		}
// 		return
// 	}
// 	if currentOfficeID.Int64 == int64(office.ID) {
// 		return errors.New("Colis déja en stock")
// 	}

// 	switch currentStateID {
// 	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
// 		return errors.New("Colis en attente de ramassage")
// 	case akwaba.ShipmentPickedUpID:
// 		return errors.New("Le colis doit quitter l'agence locale de distribution d'origin")
// 	case akwaba.ShipmentArrivedAtOfficeID:
// 		return errors.New("Le colis est en stock dans une autre agence")
// 	case akwaba.ShipmentDeliveredID:
// 		return errors.New("Colis déja livré")
// 	case akwaba.ShipmentReturnedID:
// 		return errors.New("Le colis à été retourné")
// 	}
// 	_, err = s.db.Exec(
// 		`UPDATE shipments
// 		SET current_office_id=$1, shipment_state_id=$2
// 		WHERE shipment_id=$3`,
// 		office.ID, akwaba.ShipmentArrivedAtOfficeID,
// 		shipmentID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	return
// }

// func (s *ShipmentStorage) CheckOut(office *akwaba.Office, shipmentID uint64) (err error) {
// 	var currentOfficeID, deliveryOfficeID uint
// 	var currentStateID uint8
// 	err = s.db.QueryRow(
// 		`SELECT
// 		shipment_state_id, current_office_id, delivery_office_id
// 		FROM full_shipments
// 		WHERE shipment_id=$1 AND current_office_id=$2`,
// 		shipmentID, office.ID,
// 	).Scan(&currentStateID, &currentOfficeID, &deliveryOfficeID)
// 	if err != nil {
// 		return
// 	}
// 	if currentOfficeID != office.ID {
// 		return errors.New("Le colis ne se trouve pas dans votre stock")
// 	}
// 	if deliveryOfficeID == office.ID && currentStateID != akwaba.ShipmentDeliveryFailedID {
// 		return errors.New("Le colis se trouve déja dans la zone de livraison")
// 	}

// 	switch currentStateID {
// 	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
// 		return errors.New("Colis en attente de ramassage")
// 	case akwaba.ShipmentDeliveredID:
// 		return errors.New("Colis déja livré")
// 	case akwaba.ShipmentReturnedID:
// 		return errors.New("Le colis à été retourné")
// 	}

// 	_, err = s.db.Exec(
// 		`UPDATE shipments
// 		SET current_office_id=null, shipment_state_id=$1
// 		WHERE shipment_id=$2 AND current_office_id=$3`,
// 		akwaba.ShipmentLeftOfficeID,
// 		shipmentID, office.ID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	return
// }

// func (s *ShipmentStorage) Deliveries(office *akwaba.Office) (shipments []akwaba.Shipment, err error) {
// 	rows, err := s.db.Query(
// 		`SELECT
// 		shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id,
// 		sender_area, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_area,
// 		recipient_address, time_created, shipment_category_id, shipment_category, cost, shipment_state_id,
// 		shipment_state, weight, payment_option_id, payment_option, distance, nature
// 	FROM full_shipments
// 	WHERE delivery_office_id=$1 AND current_office_id=$2;`,
// 		office.ID, office.ID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	for rows.Next() {
// 		var s akwaba.Shipment
// 		// scan order

// 		err = rows.Scan(
// 			&s.ID, &s.OrderID, &s.UserID, &s.Sender.Name, &s.Sender.Phone,
// 			&s.Sender.Area.ID, &s.Sender.Area.Name, &s.Sender.Address, &s.Recipient.Name,
// 			&s.Recipient.Phone, &s.Recipient.Area.ID, &s.Recipient.Area.Name, &s.Recipient.Address,
// 			&s.TimeCreated, &s.Category.ID, &s.Category.Name, &s.Cost, &s.State.ID, &s.State.Name,
// 			&s.Weight, &s.PaymentOption.ID, &s.PaymentOption.Name, &s.Distance, &s.Nature,
// 		)
// 		if err != nil {
// 			return
// 		}
// 		shipments = append(shipments, s)
// 	}
// 	return
// }

// func (s *ShipmentStorage) Delivered(office *akwaba.Office, shipmentID uint64) (err error) {
// 	var currentOfficeID, deliveryOfficeID uint
// 	var currentStateID uint8
// 	var orderID uint64
// 	err = s.db.QueryRow(
// 		`SELECT
// 		order_id, shipment_state_id, current_office_id, delivery_office_id
// 		FROM full_shipments
// 		WHERE shipment_id=$1 AND current_office_id=$2`,
// 		shipmentID, office.ID,
// 	).Scan(&orderID, &currentStateID, &currentOfficeID, &deliveryOfficeID)
// 	if err != nil {
// 		return
// 	}

// 	switch currentStateID {
// 	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
// 		return errors.New("Colis en attente de ramassage")
// 	case akwaba.ShipmentDeliveredID:
// 		return errors.New("Colis déja livré")
// 	case akwaba.ShipmentReturnedID:
// 		return errors.New("Le colis à été retourné")
// 	}

// 	if deliveryOfficeID != office.ID {
// 		return errors.New("La livraison de ce colis ")
// 	}

// 	_, err = s.db.Exec(
// 		`UPDATE shipments
// 		SET current_office_id=null, shipment_state_id=$1
// 		WHERE shipment_id=$2 AND current_office_id=$3`,
// 		akwaba.ShipmentDeliveredID,
// 		shipmentID, office.ID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	_, err = s.db.Exec(
// 		`UPDATE orders SET order_state_id=$1, time_closed=NOW() WHERE order_id=$2`,
// 		akwaba.OrderStateCompletedID, orderID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	return
// }

// func (s *ShipmentStorage) DeliveryFailed(office *akwaba.Office, shipmentID uint64) (err error) {
// 	var currentOfficeID, deliveryOfficeID uint
// 	var currentStateID uint8
// 	err = s.db.QueryRow(
// 		`SELECT
// 		shipment_state_id, current_office_id, delivery_office_id
// 		FROM full_shipments
// 		WHERE shipment_id=$1 AND current_office_id=$2`,
// 		shipmentID, office.ID,
// 	).Scan(&currentStateID, &currentOfficeID, &deliveryOfficeID)
// 	if err != nil {
// 		return
// 	}

// 	switch currentStateID {
// 	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
// 		return errors.New("Colis en attente de ramassage")
// 	case akwaba.ShipmentDeliveredID:
// 		return errors.New("Colis déja livré")
// 	case akwaba.ShipmentReturnedID:
// 		return errors.New("Le colis à été retourné")
// 	}

// 	if deliveryOfficeID != office.ID {
// 		return errors.New("La livraison de ce colis ")
// 	}

// 	_, err = s.db.Exec(
// 		`UPDATE shipments
// 		SET shipment_state_id=$1
// 		WHERE shipment_id=$2 AND current_office_id=$3`,
// 		akwaba.ShipmentDeliveryFailedID,
// 		shipmentID, office.ID,
// 	)
// 	if err != nil {
// 		return
// 	}
// 	return
// }
