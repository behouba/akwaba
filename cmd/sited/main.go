package main

import (
	"fmt"

	"github.com/behouba/akwaba/user/site"
)

func main() {
	dbURI := fmt.Sprintf("host=%s port=%d user=%s "+"password=%s dbname=%s sslmode=disable", "localhost", 5432, "optimus92", "labierequisait", "akwaba1")
	h := site.NewHandler(dbURI)
	r := site.SetupRouter(h)
	r.Run(":9999")
}
