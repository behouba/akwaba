package employees

import (
	"database/sql"

	"github.com/behouba/akwaba"
)

// Database represent employees database
type Database struct {
	db *sql.DB
}

func NewDatabase(dataSourceURI string) (*Database, error) {
	return nil, nil
}

func AuthenticateParcelsManager(emp *akwaba.Employee, ip string) (e akwaba.Employee, err error) {
	return
}

func AuthenticateOrdersManager(emp *akwaba.Employee, ip string) (e akwaba.Employee, err error) {
	return
}
