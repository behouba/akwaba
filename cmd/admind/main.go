package main

import (
	"github.com/behouba/dsapi/adminapi"
)

func main() {
	h := adminapi.AdminHandler("", "", "admin_secret")
	r := adminapi.SetupRouter(h)
	r.Run(":8084")
}
