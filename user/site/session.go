package site

import (
	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func getSessionUser(c *gin.Context) (user akwaba.User) {
	s := sessions.Default(c)
	if s.Get("id") != nil {
		user.ID = s.Get("id").(int)
	}
	if s.Get("name") != nil {
		user.FullName = s.Get("name").(string)
	}
	if s.Get("phone") != nil {
		user.Phone = s.Get("phone").(string)
	}
	if s.Get("email") != nil {
		user.Email = s.Get("email").(string)
	}
	return
}

func saveSessionUser(u *akwaba.User, c *gin.Context) {
	s := sessions.Default(c)
	s.Set("id", u.ID)
	s.Set("name", u.FullName)
	s.Set("phone", u.Phone)
	s.Set("email", u.Email)
	s.Save()
}

func destroySessionUser(c *gin.Context) {
	session := sessions.Default(c)
	session.Delete("id")
	session.Delete("name")
	session.Save()
}
