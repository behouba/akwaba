package accounts

import (
	"database/sql"

	"github.com/jmoiron/sqlx"
)

const insertUserSQL = `INSERT INTO users (first_name, last_name, phone, email, password) VALUES ($1, $2, $3, $4, $5) RETURNING user_id`

const insertOldUserDataSQL = `INSERT INTO user_updates (user_id, first_name, last_name, phone) VALUES ($1, $2, $3, $4);`

const insertAccessHistorySQL = "INSERT INTO users_access_history (user_id, ip_address) VALUES ($1, $2)"

const selectUserByEmailSQL = "SELECT user_id, first_name, last_name, email, phone, password FROM users WHERE email=$1"

const selectUserPasswordSQL = "SELECT password FROM users WHERE user_id=$1"

const selectUserByIDSQL = "SELECT first_name, last_name, phone FROM users WHERE user_id=$1"

const selectRecoveryTokenFromUserIDSQL = "SELECT user_id FROM users WHERE recovery_token=$1"

const updateUserPasswordSQL = "UPDATE users SET password=$1 WHERE user_id=$2"

const updateUserDataByUserIDSQL = `UPDATE users SET first_name=$1, last_name=$2, phone=$3 WHERE user_id=$4`

const updateRecoveryTokenSQL = "UPDATE users SET recovery_token=$1 WHERE email=$2"

const updateRecoveryTokenToNullSQL = "UPDATE users SET recovery_token=null, is_email_verified=true WHERE user_id=$1"

type accountStatements struct {
	insertUserStmt                    *sql.Stmt
	insertOldUserDataStmt             *sql.Stmt
	insertAccessHistoryStmt           *sql.Stmt
	selectUserByEmailStmt             *sql.Stmt
	selectUserPasswordStmt            *sql.Stmt
	selectUserByIDStmt                *sql.Stmt
	selectRecoveryTokenFromUserIDStmt *sql.Stmt
	updateUserPasswordStmt            *sql.Stmt
	updateUserDataByUserIDStmt        *sql.Stmt
	updateRecoveryTokenStmt           *sql.Stmt
	updateRecoveryTokenToNullStmt     *sql.Stmt
}

func (u *accountStatements) prepare(db *sqlx.DB) (err error) {
	if u.insertUserStmt, err = db.Prepare(insertUserSQL); err != nil {
		return
	}
	if u.insertOldUserDataStmt, err = db.Prepare(insertOldUserDataSQL); err != nil {
		return
	}
	if u.insertAccessHistoryStmt, err = db.Prepare(insertAccessHistorySQL); err != nil {
		return
	}
	if u.selectUserByEmailStmt, err = db.Prepare(selectUserByEmailSQL); err != nil {
		return
	}
	if u.selectUserByIDStmt, err = db.Prepare(selectUserByIDSQL); err != nil {
		return
	}
	if u.selectUserPasswordStmt, err = db.Prepare(selectUserPasswordSQL); err != nil {
		return
	}
	if u.selectRecoveryTokenFromUserIDStmt, err = db.Prepare(selectRecoveryTokenFromUserIDSQL); err != nil {
		return
	}
	if u.updateUserDataByUserIDStmt, err = db.Prepare(updateUserDataByUserIDSQL); err != nil {
		return
	}
	if u.updateUserPasswordStmt, err = db.Prepare(updateUserPasswordSQL); err != nil {
		return
	}
	if u.updateRecoveryTokenStmt, err = db.Prepare(updateRecoveryTokenSQL); err != nil {
		return
	}
	if u.updateRecoveryTokenToNullStmt, err = db.Prepare(updateRecoveryTokenToNullSQL); err != nil {
		return
	}
	return
}
