package main

import (
	"github.com/behouba/dsapi/adminapi"
)

func main() {
	h := adminapi.Handler{}
	r := adminapi.SetupRouter(&h)
	r.Run()
}
