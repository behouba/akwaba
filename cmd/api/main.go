package main

import (
	"fmt"
	"github.com/behouba/akwaba/public/api"
)

func main() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+"password=%s dbname=%s sslmode=disable", "localhost", 5432, "optimus92", "labierequisait", "akwabaTestDB")
	handler := userapi.UserHandler(psqlInfo, "my_secret_key1")
	r := userapi.SetupRouter(handler)
	r.Run(":8080")
}
