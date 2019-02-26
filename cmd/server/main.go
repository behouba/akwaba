package main

import (
	"github.com/behouba/dsapi/cmd/server/handler"
)

func main() {
	r := handler.SetupRouter()
	r.Run()
}
