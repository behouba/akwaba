package main

import (
	"github.com/behouba/dsapi/adminapi"
	"github.com/behouba/dsapi/store"
	_ "github.com/lib/pq"
)

func main() {
	db := store.DBConfig{
		Port:     5432,
		Host:     "localhost",
		DBName:   "akwabaTestDB",
		UserName: "optimus92",
		Password: "labierequisait",
	}
	h := adminapi.AdminHandler(db, "admin_secret")
	r := adminapi.SetupRouter(h)
	r.Run(":8084")
}
