package orders

import (
	"context"
	"database/sql"
	"fmt"
	"log"

	"github.com/behouba/akwaba"
)

func (o *statements) getUserOrders(ctx context.Context, userID uint, offset uint64) (orders []akwaba.Order, err error) {
	var rows *sql.Rows
	rows, err = o.selectOrdersWithOffsetStmt.QueryContext(ctx, userID, offset)
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

func (o *statements) isAllowedToMakeOrder(ctx context.Context, userID uint) (err error) {
	var n uint8
	o.countPendingOrdersStmt.QueryRowContext(ctx, userID, akwaba.OrderStatePendingID).Scan(&n)
	if n > 4 {
		return fmt.Errorf("Vous avez %d commades en attente de confirmation", n)
	}
	return
}

// Save order
func (s *statements) saveOrder(
	ctx context.Context, order *akwaba.Order,
) (err error) {
	err = s.isAllowedToMakeOrder(ctx, order.UserID)
	if err != nil {
		return
	}
	const orderState = akwaba.OrderStatePendingID

	err = s.insertOrderStmt.QueryRowContext(ctx,
		order.UserID, order.Sender.Name, order.Sender.Phone, order.Sender.Area.ID, order.Sender.Address,
		order.Recipient.Name, order.Recipient.Phone, order.Recipient.Area.ID, order.Recipient.Address,
		order.Category.ID, order.Nature, order.PaymentOption.ID, order.Cost, order.Distance, orderState,
	).Scan(&order.ID)
	if err != nil {
		return
	}

	_, err = s.insertOrderStateChangeStmt.ExecContext(ctx, order.ID, orderState)
	if err != nil {
		return
	}
	return
}

func (s *statements) getUserOrder(ctx context.Context, orderID uint64, userID uint) (order akwaba.Order, err error) {
	err = s.selectOrderStmt.QueryRowContext(ctx, orderID, userID).Scan(
		&order.ID, &order.ShipmentID, &order.UserID, &order.TimeCreated, &order.TimeClosed,
		&order.Sender.Name, &order.Sender.Phone, &order.Sender.Area.ID, &order.Sender.Area.Name,
		&order.Sender.Address, &order.Recipient.Name, &order.Recipient.Phone, &order.Recipient.Area.ID,
		&order.Recipient.Area.Name, &order.Recipient.Address, &order.Category.ID, &order.Category.Name,
		&order.Nature, &order.PaymentOption.ID, &order.PaymentOption.Name, &order.Cost, &order.Distance,
		&order.State.ID, &order.State.Name,
	)
	if err != nil {
		return
	}
	return
}

func (s *statements) cancelOrder(ctx context.Context, orderID uint64) (err error) {
	_, err = s.cancelOrderStmt.ExecContext(
		ctx, akwaba.OrderStateCanceledID, orderID, akwaba.OrderStatePendingID,
	)
	if err != nil {
		return
	}

	return
}
