package user

import (
	"context"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

type Storage struct {
	stmts *statements
}

func New(db *sqlx.DB) (*Storage, error) {
	stmts := statements{}
	if err := stmts.prepare(db); err != nil {
		return nil, err
	}
	return &Storage{&stmts}, nil
}

func (s *Storage) Users(ctx context.Context) (users []akwaba.User) {
	return s.stmts.users(ctx)
}
