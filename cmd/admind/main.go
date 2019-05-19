package main

import (
	"fmt"

	"github.com/behouba/akwaba/adminapi"
)

func main() {
	dbURI := fmt.Sprintf(
		"host=%s port=%d user=%s "+"password=%s dbname=%s sslmode=disable",
		"35.181.50.39", 5432, "behouba", "akwabaexpress", "akwaba_db",
	)
	handler, err := adminapi.NewHandler(dbURI)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
	r := adminapi.SetupRouter(handler)
	r.Run(":8084")
}
