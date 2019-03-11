package main

import (
	"github.com/behouba/dsapi/userapi"
)

func main() {
	handler := userapi.UserHandler("", "", "my_secret_key")
	r := userapi.SetupRouter(handler)
	r.Run()
}
