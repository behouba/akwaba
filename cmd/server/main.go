package main

import (
	"github.com/behouba/dsapi/cmd/server/router"
)

func main() {
	r := router.Setup()
	r.Run()
}
