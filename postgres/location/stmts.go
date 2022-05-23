package location

import (
	"context"
	"database/sql"

	"github.com/ttacon/libphonenumber"

	"github.com/behouba/akwaba"

	"github.com/jmoiron/sqlx"
)

// Offices() []Office
// Areas() []Area

const (
	selectAreaIDSQL     = "SELECT area_id FROM areas WHERE name LIKE '%' || $1 || '%'"
	selectAllAreasSQL   = "SELECT area_id, name, city_id FROM areas"
	selectAllOfficesSQL = "" +
		"SELECT office_id, name, address, longitude, latitude, phone1, phone2 " +
		"FROM offices ORDER BY office_id"
)

type statements struct {
	selectAllAreasStmt   *sql.Stmt
	selectAllOfficesStmt *sql.Stmt
	selectAreaIDStmt     *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {
	if s.selectAllAreasStmt, err = db.Prepare(selectAllAreasSQL); err != nil {
		return
	}
	if s.selectAllOfficesStmt, err = db.Prepare(selectAllOfficesSQL); err != nil {
		return
	}
	if s.selectAreaIDStmt, err = db.Prepare(selectAreaIDSQL); err != nil {
		return
	}
	return
}

func (s *statements) selectAreas(ctx context.Context) (areas []akwaba.Area, err error) {
	rows, err := s.selectAllAreasStmt.QueryContext(ctx)
	if err != nil {
		return
	}
	for rows.Next() {
		var a akwaba.Area
		err = rows.Scan(&a.ID, &a.Name, &a.CityID)
		if err != nil {
			return
		}
		areas = append(areas, a)
	}
	return
}

func (s *statements) selectOffices(ctx context.Context) (offices []akwaba.Office, err error) {
	rows, err := s.selectAllOfficesStmt.QueryContext(ctx)
	if err != nil {
		return
	}

	for rows.Next() {
		var o akwaba.Office
		var p1 sql.NullString
		var p2 sql.NullString
		err = rows.Scan(&o.ID, &o.Name, &o.Address, &o.Lng, &o.Lat, &p1, &p2)
		if err != nil {
			return
		}
		o.Phone1, _ = formatPhoneNumber(p1.String)
		o.Phone2, _ = formatPhoneNumber(p2.String)
		offices = append(offices, o)
	}
	return
}

func (o *statements) setAreaID(ctx context.Context, name string, id *uint) (err error) {
	return o.selectAreaIDStmt.QueryRowContext(ctx, name).Scan(id)
}

func formatPhoneNumber(phone string) (formattedNum string, err error) {
	num, err := libphonenumber.Parse(phone, "CI")
	if err != nil {
		return
	}
	formattedNum = libphonenumber.Format(num, libphonenumber.NATIONAL)
	return
}
