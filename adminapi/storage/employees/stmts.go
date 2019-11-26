package employees

import (
	"context"
	"database/sql"
	"log"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
	"golang.org/x/crypto/bcrypt"
)

const (
	selectEmployeeByLoginSQL = "" +
		"SELECT e.first_name, e.last_name, e.password, e.office_id, o.name " +
		"FROM employees AS e LEFT JOIN offices AS o ON e.office_id = o.office_id " +
		"WHERE login=$1 AND is_active=true AND position_id=1"

	insertEmployeeAccessHistorySQL = "" +
		"INSERT INTO employees_access_history (employee_id, ip_address) VALUES ($1, $2)" + ";"
)

var (
	selectOrdersManagerSQL = selectEmployeeByLoginSQL + strconv.Itoa(int(akwaba.OrdersManagerPositionID)) + ";"

	selectShipmentsManagerSQL = selectEmployeeByLoginSQL + strconv.Itoa(int(akwaba.ShipmentsManagerPositionID)) + ";"
)

type statements struct {
	selectOrdersManagerStmt         *sql.Stmt
	selectShipmentsManagerStmt      *sql.Stmt
	insertEmployeeAccessHistoryStmt *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {
	if s.selectOrdersManagerStmt, err = db.Prepare(selectOrdersManagerSQL); err != nil {
		log.Println("prepare orders manager failed")
		return
	}
	if s.selectShipmentsManagerStmt, err = db.Prepare(selectShipmentsManagerSQL); err != nil {
		log.Println("prepare shipments manager failed")
		return
	}
	if s.insertEmployeeAccessHistoryStmt, err = db.Prepare(insertEmployeeAccessHistorySQL); err != nil {
		log.Println("prepare history  access failed")
		return
	}
	return
}

func (s *statements) authenticateManager(
	ctx context.Context, emp *akwaba.Employee, positionID uint8, ip string,
) (employee akwaba.Employee, err error) {
	var passwordHash string
	var row *sql.Row
	if positionID == akwaba.OrdersManagerPositionID {
		row = s.selectOrdersManagerStmt.QueryRowContext(ctx, emp.Login)
	} else if positionID == akwaba.ShipmentsManagerPositionID {
		row = s.selectShipmentsManagerStmt.QueryRowContext(ctx, emp.Login)
	}
	err = row.Scan(
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
	s.recordLogin(ctx, employee.ID, ip)
	return
}

func (s *statements) recordLogin(ctx context.Context, empID uint, ip string) (err error) {
	_, err = s.insertEmployeeAccessHistoryStmt.ExecContext(ctx, empID, ip)
	if err != nil {
		log.Println(err)
	}
	return
}
