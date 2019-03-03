package main

import (
	"github.com/behouba/dsapi/cmd/admind/router"
)

func main() {
	r := router.Setup()
	r.Run()
}
