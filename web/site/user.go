package site

import (
	"log"
	"net/http"

	"github.com/behouba/akwaba/web/session"

	"github.com/gin-gonic/gin"
)

func (h *handler) userOrdersHTML(c *gin.Context) {
	user := session.GetWebsiteUser(c)
	c.HTML(http.StatusOK, "user-orders", gin.H{
		"user": user,
	})
}

func (h *handler) updatePasswordHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "update-password", gin.H{
		"user": session.GetWebsiteUser(c),
	})
}

func (h *handler) settingsHTML(c *gin.Context) {
	log.Println(session.GetWebsiteUser(c))
	c.HTML(http.StatusOK, "settings", gin.H{
		"user": session.GetWebsiteUser(c),
	})
}
