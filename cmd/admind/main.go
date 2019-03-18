package main

import (
	"github.com/behouba/dsapi/adminapi"
	"github.com/behouba/dsapi/store"
	_ "github.com/lib/pq"
)

func main() {
	db := adminapi.NewDBConn(store.DevDBConfig)
	jwtSecret := store.JWTDevSecret
	orderHandler := adminapi.NewOrderHandler(db, jwtSecret)
	authHandler := adminapi.NewAuthHandler(db, jwtSecret)
	r := adminapi.SetupRouter(authHandler, orderHandler)
	r.Run(":8084")
}
