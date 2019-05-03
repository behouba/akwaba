package site

import (
	"net/http"

	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func (h *Handler) home(c *gin.Context) {
	session := sessions.Default(c)

	c.HTML(http.StatusOK, "home", gin.H{
		"name": session.Get("name"),
	})
}

func (h *Handler) about(c *gin.Context) {
	session := sessions.Default(c)

	c.HTML(http.StatusOK, "about", gin.H{
		"name": session.Get("name"),
	})
}

func (h *Handler) services(c *gin.Context) {
	session := sessions.Default(c)

	c.HTML(http.StatusOK, "services", gin.H{
		"name": session.Get("name"),
	})
}
func (h *Handler) order(c *gin.Context) {
	session := sessions.Default(c)

	c.HTML(http.StatusOK, "order", gin.H{
		"name": session.Get("name"),
	})
}

func (h *Handler) tracking(c *gin.Context) {
	session := sessions.Default(c)

	c.HTML(http.StatusOK, "tracking", gin.H{
		"name": session.Get("name"),
	})
}
func (h *Handler) pricing(c *gin.Context) {
	session := sessions.Default(c)

	c.HTML(http.StatusOK, "pricing", gin.H{
		"name": session.Get("name"),
	})
}
