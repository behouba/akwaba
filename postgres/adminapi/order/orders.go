package order

import (
	"context"
	"database/sql"
	"errors"
	"log"

	"github.com/behouba/akwaba"
)

func (s *statements) selectActiveOrders(ctx context.Context) (orders []akwaba.Order, err error) {
	rows, err := s.selectActiveOrdersStmt.QueryContext(
		ctx, akwaba.OrderStatePendingID, akwaba.OrderInProcessingID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order
		err = rows.Scan(
			&o.ID, &o.ShipmentID, &o.UserID, &o.TimeCreated, &o.TimeClosed,
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

func (s *statements) selectClosedOrders(ctx context.Context, date string) (orders []akwaba.Order, err error) {
	rows, err := s.selectClosedOrdersByDateStmt.QueryContext(ctx, date)
	if err != nil {
		return
	}
	for rows.Next() {
		var o akwaba.Order
		err = rows.Scan(
			&o.ID, &o.ShipmentID, &o.UserID, &o.TimeCreated, &o.TimeClosed,
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

func (s *statements) saveOrder(
	ctx context.Context, o *akwaba.Order,
) (err error) {
	err = s.insertNewOrderStmt.QueryRowContext(
		ctx, o.Sender.Name, o.Sender.Phone, o.Sender.Area.ID, o.Sender.Address,
		o.Recipient.Name, o.Recipient.Phone, o.Recipient.Area.ID, o.Recipient.Address,
		o.Category.ID, o.Nature, o.PaymentOption.ID, o.Cost, o.Distance, akwaba.OrderStatePendingID,
	).Scan(&o.ID)
	if err != nil {
		return
	}
	return
}

// Cancel function take order id and cancel
func (s *statements) cancelOrder(ctx context.Context, orderID uint64) (err error) {
	var shipmentID uint64
	var shipmentStateID uint8
	err = s.cancelOrderStmt.QueryRowContext(
		ctx, orderID,
	).Scan(&shipmentID, &shipmentStateID)
	if err == sql.ErrNoRows {
		_, err = s.cancelPendingOrderStmt.ExecContext(
			ctx, akwaba.OrderStateCanceledID, orderID, akwaba.OrderStatePendingID,
		)
		return
	}

	if err != nil {
		return
	}

	if shipmentID > 0 &&
		shipmentStateID != akwaba.ShipmentReturnedID &&
		shipmentStateID != akwaba.ShipmentPendingPickupID {
		return errors.New("Impossible d'annuler cette commande, livraison en cours")
	}
	_, err = s.cancelOrderStmt.ExecContext(
		ctx, akwaba.OrderStateCanceledID, orderID,
	)
	if err != nil {
		return
	}
	return
}

func (s *statements) confirmOrder(ctx context.Context, orderID uint64) (shipmentID uint64, err error) {
	var orderStateID uint8
	err = s.selectOrderStateIDStmt.QueryRowContext(
		ctx, orderID,
	).Scan(&orderStateID)
	if err != nil {
		return
	}
	if orderStateID != akwaba.OrderStatePendingID {
		return 0, errors.New(
			"Désolé, impossible de confirmer cette commande. Merci de vérifier le status actuel de la commande",
		)
	}

	// shipmentID, err = a.saveShipment(&o)
	// if err != nil {
	// 	return
	// }

	return
}

func (s *statements) createShipment(ctx context.Context, orderID uint64) (shipmentID uint64, err error) {
	var o akwaba.Order

	// retreiving order data from orders table
	err = s.selectOrderDataStmt.QueryRowContext(
		ctx, orderID,
	).Scan(
		&o.ID, &o.UserID, &o.Sender.Name, &o.Sender.Phone,
		&o.Sender.Area.ID, &o.Sender.Address, &o.Recipient.Name,
		&o.Recipient.Phone, &o.Recipient.Area.ID, &o.Recipient.Address,
		&o.Category.ID, &o.Nature, &o.PaymentOption.ID, &o.Cost, &o.Distance,
	)
	if err != nil {
		return
	}

	const shipmentStateID = akwaba.ShipmentPendingPickupID
	// inserting order data in shipment table
	err = s.insertNewShipmentStmt.QueryRowContext(
		ctx, o.ID, o.UserID, o.Sender.Name, o.Sender.Phone, o.Sender.Area.ID,
		o.Sender.Address, o.Recipient.Name, o.Recipient.Phone, o.Recipient.Area.ID,
		o.Recipient.Address, o.Category.ID, o.Cost,
		o.Nature, o.PaymentOption.ID, o.Distance, shipmentStateID,
	).Scan(&shipmentID)
	if err != nil {
		return
	}

	_, err = s.insertShipmentHistoryStmt.ExecContext(
		ctx, shipmentID, shipmentStateID, o.Sender.Area.ID,
	)

	return
}

func (s *statements) updateState(ctx context.Context, orderID uint64, stateID uint8) (err error) {
	_, err = s.updateOrderStateStmt.ExecContext(
		ctx, stateID, orderID,
	)
	if err != nil {
		return
	}
	_, err = s.insertOrderHistoryStmt.ExecContext(
		ctx, orderID, stateID,
	)
	return
}
