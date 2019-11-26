package accounts

import (
	"context"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// Storage represent users account data storage
type Storage struct {
	stmts accountStatements
	// ordersStmts  ordersStatments
}

// New create new account Storage, return error if it fail
func New(db *sqlx.DB) (*Storage, error) {
	stmts := accountStatements{}
	if err := stmts.prepare(db); err != nil {
		return nil, err
	}
	return &Storage{stmts}, nil
}

// UpdateUserInfo update user info
func (d *Storage) UpdateUserInfo(ctx context.Context, user *akwaba.User) (err error) {
	return d.stmts.updateUserInfo(ctx, user)
}

// UpdatePassword update user password
func (d *Storage) UpdatePassword(
	ctx context.Context, userID uint, currentPassword, newPassword string,
) (err error) {
	return d.stmts.updateUserPassword(ctx, userID, currentPassword, newPassword)
}

// UserByEmail retreive user by user email
func (d *Storage) UserByEmail(ctx context.Context, email string) (user akwaba.User, err error) {
	return d.stmts.selectUserByEmail(ctx, email)
}

// Save method save new user info into database
// and return user struct from database with error
func (d *Storage) Save(ctx context.Context, user *akwaba.User) (err error) {
	return d.stmts.insertUser(ctx, user)
}

// Authenticate check if email and password provided are correct, return error if invalid
func (d *Storage) Authenticate(ctx context.Context, email, password, ip string) (user akwaba.User, err error) {
	return d.stmts.authenticate(ctx, email, password, ip)
}

// SetRecoveryToken save recovery token of user in users table
func (d *Storage) SetRecoveryToken(ctx context.Context, email string) (token string, err error) {
	d.stmts.setRecoveryToken(ctx, email)
	return
}

// CheckRecoveryToken check if provoded token is valid
func (d *Storage) CheckRecoveryToken(ctx context.Context, token string) (userID uint, err error) {
	return d.stmts.checkRecoveryToken(ctx, token)
}

// SaveNewPassword save new create password form account recovery
func (d *Storage) SaveNewPassword(ctx context.Context, userID uint, token, newPassword string) (err error) {
	return d.stmts.saveNewPassword(ctx, userID, token, newPassword)
}
