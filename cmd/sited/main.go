package main

import (
	"fmt"

	"github.com/behouba/akwaba/user/site"
)

const port = ":80"

func main() {
	dbURI := fmt.Sprintf(
		"host=%s port=%d user=%s "+"password=%s dbname=%s sslmode=disable",
		"35.181.50.39", 5432, "behouba", "akwabaexpress", "akwaba_db",
	)
	h := site.NewHandler(dbURI)
	r := site.SetupRouter(h)
	r.Run(port)
}
