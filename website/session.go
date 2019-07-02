package website

import (
	"fmt"

	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func sessionUser(c *gin.Context) (cust akwaba.Customer) {
	s := sessions.Default(c)
	cust, _ = s.Get("sessionUser").(akwaba.Customer)
	fmt.Println(cust)
	return
}

func saveSessionUser(cust akwaba.Customer, c *gin.Context) {
	s := sessions.Default(c)
	s.Set("sessionUser", cust)
	s.Save()
}

func destroySessionUser(c *gin.Context) {
	s := sessions.Default(c)
	s.Delete("sessionUser")
	s.Save()
}
