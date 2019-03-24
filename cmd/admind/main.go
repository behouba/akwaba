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
	userHandler := adminapi.NewUserHandler(db, jwtSecret)
	parcelHandler := adminapi.NewParcelHandler(db, jwtSecret)
	r := adminapi.SetupRouter(authHandler, orderHandler, userHandler, parcelHandler)
	r.Run(":8084")
}
