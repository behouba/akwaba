package user

import (
	"context"
	"database/sql"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

const (
	selectUsersSQL = "SELECT user_id, first_name, last_name, phone, email, password, " +
		"account_type_id, is_email_verified, is_phone_verified " +
		"FROM users LIMIT 500"
)

type statements struct {
	selectUsersStmt *sql.Stmt
}

func (s *statements) prepare(db *sqlx.DB) (err error) {
	s.selectUsersStmt, err = db.Prepare(selectUsersSQL)
	return
}
func (s *statements) users(ctx context.Context) (users []akwaba.User) {
	rows, err := s.selectUsersStmt.QueryContext(ctx)
	if err != nil {
		return
	}

	for rows.Next() {
		var c akwaba.User
		err = rows.Scan(
			&c.ID, &c.FirstName, &c.LastName, &c.Phone, &c.Email, &c.Password,
			&c.AccountTypeID, &c.IsEmailVerified,
			&c.IsPhoneVerified,
		)
		if err != nil {
			return
		}
		users = append(users, c)
	}
	return
}
