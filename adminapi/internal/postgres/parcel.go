package postgres

import (
	"fmt"
	"log"

	"github.com/behouba/akwaba"
)

func (a *AdminDB) addNewParcel(orderID, officeID int) (parcelID int, err error) {
	err = a.db.QueryRow(
		`INSERT INTO parcel (order_id, state_id, office_id) VALUES ($1, $2, $3) RETURNING id`,
		orderID, akwaba.ParcelStatePickedUp, officeID,
	).Scan(&parcelID)
	if err != nil {
		return
	}
	trackID, err := akwaba.EncodeParcelID(parcelID)
	if err != nil {
		return
	}
	_, err = a.db.Exec(
		`UPDATE parcel SET track_id=$1 WHERE id=$2`,
		trackID, parcelID,
	)
	if err != nil {
		return
	}
	return
}

func (a *AdminDB) OfficeParcels(emp *akwaba.Employee) (parcels []akwaba.Parcel, err error) {
	rows, err := a.db.Query(
		`SELECT
			d.id, pt.name , cost, 
			sender_full_name, sender_phone, sc.name, 
			sender_address, receiver_full_name, receiver_phone, 
			rc.name, receiver_address, note, 
			nature,w.name , created_at,
			d.state_id, ost.name, p.id, p.track_id
		FROM delivery_order as d
		LEFT JOIN order_state as ost ON
			d.state_id = ost.id
		LEFT JOIN city as sc ON
			d.sender_city_id = sc.id
		LEFT JOIN city as rc ON
			d.receiver_city_id = rc.id
		LEFT JOIN payment_type as pt ON
			d.payment_type_id = pt.id
		LEFT JOIN weight_interval as w ON
			d.weight_interval_id = w.id
		LEFT JOIN parcel as p ON
			p.order_id = d.id
		WHERE p.office_id=$1 AND p.state_id != $2
		ORDER BY created_at DESC;`,
		emp.Office.ID, akwaba.ParcelStateDelivered,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.Parcel

		err = rows.Scan(&p.ID, &p.PaymentType.Name, &p.Cost, &p.Sender.FullName,
			&p.Sender.Phone, &p.Sender.City.Name, &p.Sender.Address,
			&p.Receiver.FullName, &p.Receiver.Phone, &p.Receiver.City.Name,
			&p.Receiver.Address, &p.Note, &p.Nature, &p.WeightInterval.Name, &p.CreatedAt.RealTime,
			&p.State.ID, &p.State.Name, &p.ParcelID, &p.TrackID,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		p.CreatedAt.FormatTimeFR()
		parcels = append(parcels, p)
	}
	return
}

// ParcelsOut set parcel out of office
func (a *AdminDB) ParcelsOut(ids []int64, officeID int) {
	for _, id := range ids {
		_, err := a.db.Exec(
			`UPDATE parcel SET office_id=null, state_id=$1 
			WHERE office_id=$2 AND id=$3 AND state_id != $4`,
			akwaba.ParcelStateOnTheWay, officeID, id, akwaba.ParcelStateDelivered,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		go a.recordActivity(fmt.Sprintf("Le colis %d a quitté le bureau %d", id, officeID))
	}

}

func (a *AdminDB) ParcelIn(parcelID int, emp *akwaba.Employee) (err error) {
	_, err = a.db.Exec(
		`UPDATE parcel SET office_id=$1 WHERE id=$2`,
		emp.Office.ID, parcelID,
	)
	if err != nil {
		return
	}
	go a.recordActivity(fmt.Sprintf("Le colis %d est arrivé à l'agence %s", parcelID, emp.Office.Name))
	return
}

func (a *AdminDB) ParcelsToDeliver(emp *akwaba.Employee) (parcels []akwaba.Parcel, err error) {
	rows, err := a.db.Query(
		`
		SELECT
			d.id, pt.name , cost, 
			sender_full_name, sender_phone, sc.name, 
			sender_address, receiver_full_name, receiver_phone, 
			rc.name, receiver_address, note, 
			nature,w.name , created_at,
			d.state_id, ost.name, p.id, p.track_id
		FROM delivery_order as d
		LEFT JOIN order_state as ost ON
			d.state_id = ost.id
		LEFT JOIN city as sc ON
			d.sender_city_id = sc.id
		LEFT JOIN city as rc ON
			d.receiver_city_id = rc.id
		LEFT JOIN payment_type as pt ON
			d.payment_type_id = pt.id
		LEFT JOIN weight_interval as w ON
			d.weight_interval_id = w.id
		LEFT JOIN parcel as p ON
			p.order_id = d.id
		WHERE p.office_id=$1 AND rc.office_id=$2 AND p.state_id != $3
		ORDER BY created_at DESC;
		`,
		emp.Office.ID, emp.Office.ID, akwaba.ParcelStateDelivered,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.Parcel

		err = rows.Scan(&p.ID, &p.PaymentType.Name, &p.Cost, &p.Sender.FullName,
			&p.Sender.Phone, &p.Sender.City.Name, &p.Sender.Address,
			&p.Receiver.FullName, &p.Receiver.Phone, &p.Receiver.City.Name,
			&p.Receiver.Address, &p.Note, &p.Nature, &p.WeightInterval.Name, &p.CreatedAt.RealTime,
			&p.State.ID, &p.State.Name, &p.ParcelID, &p.TrackID,
		)
		if err != nil {
			log.Println(err)
			continue
		}
		p.CreatedAt.FormatTimeFR()
		parcels = append(parcels, p)
	}
	return
}

func (a *AdminDB) SetDeliveredParcels(ids []int, emp *akwaba.Employee) (err error) {
	for _, id := range ids {
		_, err = a.db.Exec(
			`UPDATE parcel SET state_id=$1, office_id=null WHERE id=$2 AND state_id!=$3 AND office_id=$4`,
			akwaba.ParcelStateDelivered, id, akwaba.ParcelStateDelivered, emp.Office.ID,
		)
		log.Println(id)

		if err != nil {
			log.Println(err)
			continue
		}
		go a.recordActivity(fmt.Sprintf("Colis %d livré", id))
	}
	return
}
