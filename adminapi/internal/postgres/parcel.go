package postgres

import (
	"database/sql"
	"errors"
	"log"

	"github.com/behouba/akwaba"
)

func (a *AdminDB) addNewParcel(orderID uint64, officeID uint8) (parcelID uint64, err error) {
	err = a.db.QueryRow(
		`INSERT INTO parcel (order_id, state_id, office_id) VALUES ($1, $2, $3) RETURNING id`,
		orderID, akwaba.ParcelWaitingPickup.ID, officeID,
	).Scan(&parcelID)
	if err != nil {
		return
	}
	trackID, err := akwaba.EncodeParcelID(int64(parcelID))
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

// ParcelsToPickUp retreive all parcels waiting to be picked up by provided office id
func (a *AdminDB) ParcelsToPickUp(officeID uint8) (parcels []akwaba.Parcel, err error) {
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
		WHERE sc.office_id=$1 AND p.state_id = $2
		ORDER BY created_at DESC;`,
		officeID, akwaba.ParcelWaitingPickup.ID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.Parcel

		err = rows.Scan(&p.OrderID, &p.PaymentType.Name, &p.Cost, &p.Sender.FullName,
			&p.Sender.Phone, &p.Sender.City.Name, &p.Sender.Address,
			&p.Receiver.FullName, &p.Receiver.Phone, &p.Receiver.City.Name,
			&p.Receiver.Address, &p.Note, &p.Nature, &p.ShipmentCategory.Name, &p.CreatedAt.RealTime,
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

func (a *AdminDB) OfficeParcels(emp *akwaba.Employee) (parcels []akwaba.Parcel, err error) {
	rows, err := a.db.Query(
		`SELECT
			d.id, pt.name , cost, 
			sender_full_name, sender_phone, sc.name, 
			sender_address, receiver_full_name, receiver_phone, 
			rc.name, receiver_address, note, 
			nature,w.name , created_at,
			d.state_id, ost.name, p.id, p.track_id, p.weight
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
		WHERE p.office_id=$1 AND p.state_id = $2
		ORDER BY created_at DESC;`,
		emp.Office.ID, akwaba.ParcelOnTheWay.ID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.Parcel

		err = rows.Scan(&p.OrderID, &p.PaymentType.Name, &p.Cost, &p.Sender.FullName,
			&p.Sender.Phone, &p.Sender.City.Name, &p.Sender.Address,
			&p.Receiver.FullName, &p.Receiver.Phone, &p.Receiver.City.Name,
			&p.Receiver.Address, &p.Note, &p.Nature, &p.ShipmentCategory.Name, &p.CreatedAt.RealTime,
			&p.State.ID, &p.State.Name, &p.ParcelID, &p.TrackID, &p.Weight,
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

// ParcelOut set parcel out of office
func (a *AdminDB) ParcelOut(parcelID uint64, emp *akwaba.Employee) (err error) {
	officeID, stateID, originOfficeID, destOfficeID, err := a.officeStateDestination(parcelID)
	if err != nil {
		return
	}

	if stateID.Int64 == int64(akwaba.ParcelDelivered.ID) {
		return errors.New("Operation invalide: Ce colis à déja été livré")
	}

	log.Println(officeID.Int64, int64(emp.Office.ID))
	if officeID.Int64 != int64(emp.Office.ID) {
		return errors.New("Operation invalide: Ce colis ne se trouve pas dans votre stock")
	}

	if destOfficeID.Int64 == int64(emp.Office.ID) && stateID.Int64 != int64(akwaba.ParcelFailedDelivery.ID) {
		return errors.New("Operation invalide: Ce colis doit être livré dans dans cette zone")
	}
	_, err = a.db.Exec(
		`UPDATE parcel 
		 SET office_id=null, state_id=$1 
		 WHERE office_id=$2 AND id=$3`,
		akwaba.ParcelOnTheWay.ID, emp.Office.ID, parcelID,
	)
	if err != nil {
		log.Println(err)
		return
	}
	if originOfficeID.Int64 == int64(emp.Office.ID) {
		go a.recordTrackingEvent(parcelID, akwaba.EventLeftOriginOffice, emp.Office.ID)
	} else {
		go a.recordTrackingEvent(parcelID, akwaba.EventLeftTransitOffice, emp.Office.ID)
	}
	return
	// go a.recordActivity(fmt.Sprintf("Le colis %d a quitté le bureau %d", parcelID, emp.Office.ID))
}

// ParcelIn add parcel to office's parcel stock
func (a *AdminDB) ParcelIn(parcelID uint64, emp *akwaba.Employee) (err error) {
	officeID, stateID, _, destOfficeID, err := a.officeStateDestination(parcelID)
	if err != nil {
		return
	}
	if stateID.Int64 == int64(akwaba.ParcelDelivered.ID) {
		return errors.New("Ce colis à déja été livré")
	}
	if officeID.Int64 == int64(emp.Office.ID) {
		return errors.New("Ce colis est déja en stock")
	}
	if officeID.Int64 != 0 {
		return errors.New("Ce colis est en stock dans une autre agence, impossible de l'enregistrer ici")
	}
	_, err = a.db.Exec(
		`UPDATE parcel SET office_id=$1, state_id=$2 WHERE id=$3`,
		emp.Office.ID, akwaba.ParcelOnTheWay.ID, parcelID,
	)
	if err != nil {
		return
	}

	if destOfficeID.Int64 == int64(emp.Office.ID) {
		go a.recordTrackingEvent(parcelID, akwaba.EventArrivedAtDestination, emp.Office.ID)
	} else {
		go a.recordTrackingEvent(parcelID, akwaba.EventArrivedAtTransitOffice, emp.Office.ID)
	}
	// go a.recordActivity(fmt.Sprintf("Le colis %d est arrivé à l'agence %s", parcelID, emp.Office.Name))
	return
}

func (a AdminDB) officeStateDestination(parcelID uint64) (office, state, originOffice, destOffice sql.NullInt64, err error) {
	err = a.db.QueryRow(
		`SELECT p.office_id, p.state_id, sc.office_id, rc.office_id
		FROM parcel AS p
		LEFT JOIN delivery_order AS d
		ON d.id=p.order_id
		LEFT JOIN city AS sc
		ON sc.id = d.sender_city_id
		LEFT JOIN city AS rc
		ON rc.id = d.receiver_city_id
		WHERE p.id=$1`,
		parcelID,
	).Scan(&office, &state, &originOffice, &destOffice)
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
			pst.id, pst.name, p.id, p.track_id, p.weight
		FROM delivery_order as d
		LEFT JOIN parcel as p ON
			p.order_id = d.id
		LEFT JOIN parcel_state as pst ON
			p.state_id = pst.id
		LEFT JOIN city as sc ON
			d.sender_city_id = sc.id
		LEFT JOIN city as rc ON
			d.receiver_city_id = rc.id
		LEFT JOIN payment_type as pt ON
			d.payment_type_id = pt.id
		LEFT JOIN weight_interval as w ON
			d.weight_interval_id = w.id
		WHERE p.office_id=$1 AND rc.office_id=$2 AND p.state_id != $3 
		ORDER BY created_at DESC;
		`,
		emp.Office.ID, emp.Office.ID, akwaba.ParcelDelivered.ID,
	)
	if err != nil {
		return
	}
	for rows.Next() {
		var p akwaba.Parcel

		err = rows.Scan(&p.OrderID, &p.PaymentType.Name, &p.Cost, &p.Sender.FullName,
			&p.Sender.Phone, &p.Sender.City.Name, &p.Sender.Address,
			&p.Receiver.FullName, &p.Receiver.Phone, &p.Receiver.City.Name,
			&p.Receiver.Address, &p.Note, &p.Nature, &p.ShipmentCategory.Name, &p.CreatedAt.RealTime,
			&p.State.ID, &p.State.Name, &p.ParcelID, &p.TrackID, &p.Weight,
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

func (a *AdminDB) SetDeliveredParcel(parcelID uint64, emp *akwaba.Employee) (err error) {
	var stateID, receiverCityOfficeID sql.NullInt64
	err = a.db.QueryRow(
		`SELECT p.state_id, rc.office_id
		 FROM parcel AS p 
		 LEFT JOIN delivery_order AS d
		 ON p.order_id = d.id
		 LEFT JOIN city AS rc
		 ON d.receiver_city_id = rc.id
		 WHERE p.id=$1`,
		parcelID,
	).Scan(&stateID, &receiverCityOfficeID)
	if err != nil {
		return
	}

	if stateID.Int64 == int64(akwaba.ParcelDelivered.ID) {
		return errors.New("Ce colis à déja été livré")
	}
	if receiverCityOfficeID.Int64 != int64(emp.Office.ID) {
		return errors.New("Votre n'êtes pas autorisé d'éffectuer cette opération")
	}
	_, err = a.db.Exec(
		`UPDATE parcel SET state_id=$1, office_id=null WHERE id=$2 AND state_id!=$3 AND office_id=$4`,
		akwaba.ParcelDelivered.ID, parcelID, akwaba.ParcelDelivered.ID, emp.Office.ID,
	)
	if err != nil {
		log.Println(err)
		return
	}
	go a.recordTrackingEvent(parcelID, akwaba.EventDelivered, emp.Office.ID)
	// go a.recordActivity(fmt.Sprintf("Colis %d livré", parcelID))
	return
}

func (a *AdminDB) SetDeliveryFailed(parcelID uint64, emp *akwaba.Employee) (err error) {
	var stateID, receiverCityOfficeID sql.NullInt64
	err = a.db.QueryRow(
		`SELECT p.state_id, rc.office_id
		 FROM parcel AS p 
		 LEFT JOIN delivery_order AS d
		 ON p.order_id = d.id
		 LEFT JOIN city AS rc
		 ON d.receiver_city_id = rc.id
		 WHERE p.id=$1`,
		parcelID,
	).Scan(&stateID, &receiverCityOfficeID)
	if err != nil {
		return
	}

	if stateID.Int64 == int64(akwaba.ParcelDelivered.ID) {
		return errors.New("Ce colis à déja été livré")
	}
	if receiverCityOfficeID.Int64 != int64(emp.Office.ID) {
		return errors.New("Votre n'êtes pas autorisé d'éffectuer cette opération")
	}
	_, err = a.db.Exec(
		`UPDATE parcel SET state_id=$1 WHERE id=$2 AND state_id!=$3 AND office_id=$4`,
		akwaba.ParcelFailedDelivery.ID, parcelID, akwaba.ParcelDelivered.ID, emp.Office.ID,
	)
	if err != nil {
		log.Println(err)
		return
	}
	go a.recordTrackingEvent(parcelID, akwaba.EventFailedDelivery, emp.Office.ID)
	// go a.recordActivity(fmt.Sprintf("Colis %d livré", parcelID))
	return
}

func (a *AdminDB) changeParcelState(parcelID uint64, state *akwaba.ParcelState) (err error) {
	var currentStateID uint8
	err = a.db.QueryRow(
		`SELECT state_id from parcel WHERE id=$1`,
		parcelID,
	).Scan(&currentStateID)
	if err != nil {
		return
	}
	// log.Printf("current state %d, new state %d", currentStateID, stateID)
	// err = checkStateChangeValidity(currentStateID, stateID)
	// if err != nil {
	// 	return
	// }

	// should define a trigger function to validate state change validity
	_, err = a.db.Exec(
		`UPDATE parcel SET state_id=$1 WHERE id=$2;`,
		state.ID, parcelID,
	)
	if err != nil {
		return
	}
	return
}

func (a *AdminDB) SetCollected(parcelID uint64, weight float64, officeID uint8) (err error) {
	err = a.changeParcelState(parcelID, &akwaba.ParcelOnTheWay)
	if err != nil {
		log.Println(err)
		return
	}

	go func() {
		a.db.Exec("UPDATE parcel SET weight=$1, office_id=$2 WHERE id=$3", weight, officeID, parcelID)
		a.recordTrackingEvent(parcelID, akwaba.EventPickedUp, officeID)
	}()
	return
}
