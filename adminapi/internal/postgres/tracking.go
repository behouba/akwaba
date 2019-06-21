package postgres

import (
	"log"

	"github.com/behouba/akwaba"
)

func (a *AdminDB) recordTrackingEvent(parcelID uint64, event akwaba.Event, officeID uint8) (err error) {
	_, err = a.db.Exec(
		`INSERT INTO tracking (parcel_id, title, office_id) VALUES ($1, $2, $3)`,
		parcelID, event.Title, officeID,
	)
	if err != nil {
		log.Println(err)
	}
	return
}

func (a *AdminDB) TrackParcel(parcelID uint64) (t akwaba.Tracking, err error) {
	err = a.db.QueryRow(
		`SELECT
			d.sender_full_name, d.sender_phone, sc.name, sc.id,
			d.sender_address, d.receiver_full_name, d.receiver_phone, 
			rc.name, rc.id, d.receiver_address,
			d.nature, p.weight, p.track_id
		FROM delivery_order as d
		LEFT JOIN city as sc ON
			d.sender_city_id = sc.id
		LEFT JOIN city as rc ON
			d.receiver_city_id = rc.id
		LEFT JOIN parcel as p ON
			p.order_id = d.id
		WHERE p.id=$1;`,
		parcelID,
	).Scan(
		&t.Sender.FullName, &t.Sender.Phone, &t.Sender.City.Name,
		&t.Sender.City.ID, &t.Sender.Address, &t.Receiver.FullName,
		&t.Receiver.Phone, &t.Receiver.City.Name, &t.Receiver.City.ID,
		&t.Receiver.Address, &t.Nature, &t.Weight, &t.TrackID,
	)
	if err != nil {
		return
	}

	rows, err := a.db.Query(
		`SELECT t.title, t.created_at, o.name 
		FROM tracking AS t
		LEFT JOIN office as o
		ON t.office_id = o.id
		WHERE parcel_id=$1 ORDER BY t.created_at DESC`,
		parcelID,
	)
	if err != nil {
		return
	}

	for rows.Next() {
		var e akwaba.Event
		err := rows.Scan(&e.Title, &e.Time.RealTime, &e.Office.Name)
		if err != nil {
			log.Println(err)
			continue
		}
		e.Time.FormatTimeFR()
		t.History = append(t.History, e)
	}
	return
}
