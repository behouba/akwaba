package site

import (
	"log"
	"net/http"

	"github.com/behouba/akwaba/web/session"

	"github.com/gin-gonic/gin"
)

func (h *handler) homeHTML(c *gin.Context) {

	c.HTML(http.StatusOK, "home", gin.H{
		"user": session.GetWebsiteUser(c),
	})
}

func (h *handler) aboutHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "about", gin.H{
		"user":    session.GetWebsiteUser(c),
		"offices": h.locationService.Offices(c),
	})
}

func (h *handler) servicesHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "services", gin.H{
		"user": session.GetWebsiteUser(c),
	})
}

func (h *handler) conditionsHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "conditions", gin.H{
		"user": session.GetWebsiteUser(c),
	})
}

func (h *handler) privacyPolicyHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "privacy", gin.H{
		"user": session.GetWebsiteUser(c),
	})
}

func (h *handler) noRouteHTML(c *gin.Context) {
	log.Println("404 page route triggered")
	c.HTML(http.StatusNotFound, "404", nil)
}

func (h *handler) trackingHTML(c *gin.Context) {

	c.HTML(http.StatusOK, "tracking", gin.H{
		"user": session.GetWebsiteUser(c),
	})
}
