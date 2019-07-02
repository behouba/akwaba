package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/behouba/akwaba/user/site"
)

const prodPort = ":80"
const devPort = ":8080"

func main() {
	dbURI := fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=disable connect_timeout=100",
		"35.181.50.39", 5432, "behouba", "akwabaexpress", "akwaba_db",
	)
	// gin.SetMode(gin.ReleaseMode)

	h := site.NewHandler(dbURI)
	router := site.SetupRouter(h)

	s := &http.Server{
		Addr:           devPort,
		Handler:        router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	s.ListenAndServe()
}
