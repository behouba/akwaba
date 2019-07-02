package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/behouba/akwaba/website"
	"gopkg.in/yaml.v2"
)

func main() {
	var config website.Config
	bs, err := ioutil.ReadFile("/Users/a1/Documents/code/akwaba/dev-config.yml")
	if err != nil {
		log.Fatal(err)
	}
	err = yaml.Unmarshal(bs, &config)
	if err != nil {
		log.Fatal(err)
	}
	// gin.SetMode(gin.ReleaseMode)

	router := website.NewRouter(website.NewHandler(&config))

	s := &http.Server{
		Addr:           getPort(),
		Handler:        router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	err = s.ListenAndServe()
	if err != nil {
		log.Fatal(err)
	}
}

func getPort() (port string) {
	if len(os.Args) == 1 {
		return ":8080"
	}
	env := os.Args[1]
	if env == "prod" {
		return ":80"
	}
	return ":8080"
}
