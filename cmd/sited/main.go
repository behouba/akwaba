package main

import (
	"github.com/behouba/akwaba/user/site"
)

func main() {
	r := site.SetupRouter()
	r.Run(":8080")
}
