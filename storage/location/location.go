package location

import (
	"context"
	"log"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
)

// Service is a location service to retreive cities, areas and offices
type Service struct {
	// db    *sqlx.DB
	stmts statements
}

func New(db *sqlx.DB) (*Service, error) {
	stmts := statements{}

	if err := stmts.prepare(db); err != nil {
		return nil, err
	}
	return &Service{stmts}, nil
}

// Offices retreive all offices from database
func (s *Service) Offices(ctx context.Context) (offices []akwaba.Office) {
	offices, err := s.stmts.selectOffices(ctx)
	if err != nil {
		log.Println(err)
	}
	return
}

// Areas retreive all areas from database
func (s *Service) Areas(ctx context.Context) (areas []akwaba.Area) {
	areas, err := s.stmts.selectAreas(ctx)
	if err != nil {
		log.Println(err)
	}
	return
}

func (s *Service) SetAreaID(ctx context.Context, name string, id *uint) (err error) {
	return s.stmts.setAreaID(ctx, name, id)
}

// Areas() []Area
