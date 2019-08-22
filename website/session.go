package website

import (
	"fmt"

	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func sessionUser(c *gin.Context) (user akwaba.User) {
	s := sessions.Default(c)
	user, _ = s.Get("sessionUser").(akwaba.User)
	fmt.Println(user)
	return
}

func saveSessionUser(user *akwaba.User, c *gin.Context) {
	// make password empty before saving user data into session
	user.Password = ""
	s := sessions.Default(c)
	s.Set("sessionUser", *user)
	s.Save()
}

func destroySessionUser(c *gin.Context) {
	s := sessions.Default(c)
	s.Delete("sessionUser")
	s.Save()
}
