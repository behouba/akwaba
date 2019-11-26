package shipment

import (
	"context"
	"database/sql"
	"errors"
	"log"

	"github.com/behouba/akwaba"
)

var (
	errWrongDeliveryOffice    = errors.New("La livraison de ce colis ")
	errShipmentReturned       = errors.New("Le colis à été retourné")
	errShipmentDelivered      = errors.New("Colis déja livré")
	errCheckInNotAllowed      = errors.New("Le colis est en stock dans une autre agence")
	errShouldLeftOriginBefore = errors.New("Le colis doit quitter l'agence locale de distribution d'origine")
	errPendingPickup          = errors.New("Colis en attente de ramassage")
	errNotInStock             = errors.New("Le colis ne se trouve pas dans votre stock")
	errAlreadyInDeliveryArea  = errors.New("Le colis se trouve déja dans la zone de livraison")
)

func (s *statements) pickups(
	ctx context.Context, office *akwaba.Office,
) (shipments []akwaba.Shipment, err error) {
	rows, err := s.selectShipmentsToPickupStmt.QueryContext(
		ctx, office.ID, akwaba.ShipmentPendingPickupID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var s akwaba.Shipment

		err = rows.Scan(
			&s.ID, &s.OrderID, &s.UserID, &s.Sender.Name, &s.Sender.Phone,
			&s.Sender.Area.ID, &s.Sender.Area.Name, &s.Sender.Address, &s.Recipient.Name,
			&s.Recipient.Phone, &s.Recipient.Area.ID, &s.Recipient.Area.Name, &s.Recipient.Address,
			&s.TimeCreated, &s.Category.ID, &s.Category.Name, &s.Cost, &s.State.ID, &s.State.Name,
			&s.PaymentOption.ID, &s.PaymentOption.Name, &s.Distance, &s.Nature,
		)
		if err != nil {
			return
		}
		shipments = append(shipments, s)
	}
	return
}

func (s *statements) pickedUp(
	ctx context.Context, office *akwaba.Office, shipmentID uint64, weight float64,
) (err error) {
	_, err = s.shipmentPickedUpStmt.ExecContext(
		ctx, weight, akwaba.ShipmentPickedUpID, office.ID, shipmentID,
	)
	if err != nil {
		log.Println(err)
		return
	}
	return
}

func (s *statements) updateState(
	ctx context.Context, shipmentID uint64, stateID uint8, areaID uint,
) (err error) {
	// set delivery time if updating state to shipment delivered state
	_, err = s.insertShipmentHistoryStmt.ExecContext(
		ctx, shipmentID, stateID, areaID,
	)
	if err != nil {
		return
	}
	return
}

func (s *statements) stock(ctx context.Context, office *akwaba.Office) (shipments []akwaba.Shipment, err error) {
	rows, err := s.selectShipmentsInStockStmt.QueryContext(ctx, office.ID)
	if err != nil {
		return
	}
	for rows.Next() {
		var s akwaba.Shipment
		// scan order

		err = rows.Scan(
			&s.ID, &s.OrderID, &s.UserID, &s.Sender.Name, &s.Sender.Phone,
			&s.Sender.Area.ID, &s.Sender.Area.Name, &s.Sender.Address, &s.Recipient.Name,
			&s.Recipient.Phone, &s.Recipient.Area.ID, &s.Recipient.Area.Name, &s.Recipient.Address,
			&s.TimeCreated, &s.Category.ID, &s.Category.Name, &s.Cost, &s.State.ID, &s.State.Name,
			&s.Weight, &s.PaymentOption.ID, &s.PaymentOption.Name, &s.Distance, &s.Nature,
		)
		if err != nil {
			return
		}
		shipments = append(shipments, s)
	}
	return
}

func (s *statements) CheckIn(ctx context.Context, office *akwaba.Office, shipmentID uint64) (err error) {
	var currentOfficeID sql.NullInt64
	var currentStateID uint8
	err = s.selectCurrentOfficeIDAndStateIDStmt.QueryRowContext(
		ctx, shipmentID,
	).Scan(&currentOfficeID, &currentStateID)
	if err != nil {
		if err == sql.ErrNoRows {
			err = errors.New("Aucun colis trouvé")
		}
		return
	}
	if currentOfficeID.Int64 == int64(office.ID) {
		return errors.New("Colis déja en stock")
	}

	switch currentStateID {
	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
		return errPendingPickup
	case akwaba.ShipmentPickedUpID:
		return errShouldLeftOriginBefore
	case akwaba.ShipmentArrivedAtOfficeID:
		return errCheckInNotAllowed
	case akwaba.ShipmentDeliveredID:
		return errShipmentDelivered
	case akwaba.ShipmentReturnedID:
		return errShipmentReturned
	}
	_, err = s.checkInShipmentStmt.ExecContext(
		ctx, office.ID, akwaba.ShipmentArrivedAtOfficeID, shipmentID,
	)
	if err != nil {
		return
	}
	return
}

func (s *statements) checkOut(ctx context.Context, office *akwaba.Office, shipmentID uint64) (err error) {
	var currentOfficeID, deliveryOfficeID uint
	var currentStateID uint8
	err = s.selectOfficesIDsStateIDStmt.QueryRowContext(
		ctx, shipmentID, office.ID,
	).Scan(&currentStateID, &currentOfficeID, &deliveryOfficeID)
	if err != nil {
		return
	}
	if currentOfficeID != office.ID {
		return errNotInStock
	}
	if deliveryOfficeID == office.ID && currentStateID != akwaba.ShipmentDeliveryFailedID {
		return errAlreadyInDeliveryArea
	}

	switch currentStateID {
	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
		return errPendingPickup
	case akwaba.ShipmentDeliveredID:
		return errShipmentDelivered
	case akwaba.ShipmentReturnedID:
		return errShipmentReturned
	}

	_, err = s.checkOutShipmentStmt.ExecContext(
		ctx, akwaba.ShipmentLeftOfficeID, shipmentID, office.ID,
	)
	if err != nil {
		return
	}
	return
}

func (s *statements) deliveries(
	ctx context.Context, office *akwaba.Office,
) (shipments []akwaba.Shipment, err error) {
	rows, err := s.selectShipmentToDeliverStmt.QueryContext(
		ctx, office.ID, office.ID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var s akwaba.Shipment
		// scan order

		err = rows.Scan(
			&s.ID, &s.OrderID, &s.UserID, &s.Sender.Name, &s.Sender.Phone,
			&s.Sender.Area.ID, &s.Sender.Area.Name, &s.Sender.Address, &s.Recipient.Name,
			&s.Recipient.Phone, &s.Recipient.Area.ID, &s.Recipient.Area.Name, &s.Recipient.Address,
			&s.TimeCreated, &s.Category.ID, &s.Category.Name, &s.Cost, &s.State.ID, &s.State.Name,
			&s.Weight, &s.PaymentOption.ID, &s.PaymentOption.Name, &s.Distance, &s.Nature,
		)
		if err != nil {
			return
		}
		shipments = append(shipments, s)
	}
	return
}

func (s *statements) delivered(ctx context.Context, office *akwaba.Office, shipmentID uint64) (err error) {
	var currentOfficeID, deliveryOfficeID uint
	var currentStateID uint8
	var orderID uint64
	err = s.selectOfficesIDsStateIDAndOrderIDStmt.QueryRowContext(
		ctx, shipmentID, office.ID,
	).Scan(&orderID, &currentStateID, &currentOfficeID, &deliveryOfficeID)
	if err != nil {
		return
	}

	switch currentStateID {
	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
		return errPendingPickup
	case akwaba.ShipmentDeliveredID:
		return errShipmentDelivered
	case akwaba.ShipmentReturnedID:
		return errShipmentReturned
	}

	if deliveryOfficeID != office.ID {
		return errWrongDeliveryOffice
	}

	_, err = s.checkOutShipmentStmt.ExecContext(
		ctx, akwaba.ShipmentDeliveredID,
		shipmentID, office.ID,
	)
	if err != nil {
		return
	}
	_, err = s.closeOrderStmt.ExecContext(
		ctx, akwaba.OrderStateCompletedID, orderID,
	)
	if err != nil {
		return
	}
	return
}

func (s *statements) deliveryFailed(ctx context.Context, office *akwaba.Office, shipmentID uint64) (err error) {
	var currentOfficeID, deliveryOfficeID uint
	var currentStateID uint8
	err = s.selectOfficesIDsStateIDStmt.QueryRowContext(
		ctx, shipmentID, office.ID,
	).Scan(&currentStateID, &currentOfficeID, &deliveryOfficeID)
	if err != nil {
		return
	}

	switch currentStateID {
	case akwaba.ShipmentPendingPickupID, akwaba.ShipmentPickupFailedID:
		return errPendingPickup
	case akwaba.ShipmentDeliveredID:
		return errShipmentDelivered
	case akwaba.ShipmentReturnedID:
		return errShipmentReturned
	}

	if deliveryOfficeID != office.ID {
		return errWrongDeliveryOffice
	}

	_, err = s.failedDeliveryStmt.ExecContext(
		ctx, akwaba.ShipmentDeliveryFailedID,
		shipmentID, office.ID,
	)
	if err != nil {
		return
	}
	return
}
