package main

import (
	"github.com/behouba/dsapi/userapi"
)

func main() {
	dbURI := "postgres://zayirtdpcnrbbi:f4700b1760093736df257b9f586e7eae06784cab0001bc297d8a91aec8848a29@ec2-184-73-210-189.compute-1.amazonaws.com:5432/d2ql9119ssjr1i"
	handler := userapi.UserHandler(dbURI, "my_secret_key1")
	r := userapi.SetupRouter(handler)
	r.Run(":8080")
}
