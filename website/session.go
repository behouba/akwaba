package website

import (
	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func (h *Handler) contextUser(c *gin.Context) (user akwaba.User) {
	user = sessionUser(c)
	if user.ID != 0 {
		return
	}
	return h.apiUser(c)
}

func sessionUser(c *gin.Context) (user akwaba.User) {
	s := sessions.Default(c)
	user, _ = s.Get("sessionUser").(akwaba.User)
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
