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
	if s.Get("cityID") != nil {
		user.City.ID = s.Get("cityID").(int)
	}
	if s.Get("cityName") != nil {
		user.City.Name = s.Get("cityName").(string)
	}
	if s.Get("address") != nil {
		user.Address = s.Get("address").(string)
	}
	return
}

func saveSessionUser(u *akwaba.User, c *gin.Context) {
	s := sessions.Default(c)
	s.Set("id", u.ID)
	s.Set("name", u.FullName)
	s.Set("phone", u.Phone)
	s.Set("email", u.Email)
	s.Set("cityID", u.City.ID)
	s.Set("cityName", u.City.Name)
	s.Set("address", u.Address)
	s.Save()
}

func destroySessionUser(c *gin.Context) {
	session := sessions.Default(c)
	session.Delete("id")
	session.Delete("name")
	session.Save()
}
