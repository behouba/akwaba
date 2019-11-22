package website

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) homeHTML(c *gin.Context) {

	c.HTML(http.StatusOK, "home", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) aboutHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "about", gin.H{
		"user":    sessionUser(c),
		"offices": h.sysData.Offices(),
	})
}

func (h *Handler) servicesHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "services", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) conditionsHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "conditions", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) privacyPolicyHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "privacy", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) noRouteHTML(c *gin.Context) {
	log.Println("404 page route triggered")
	c.HTML(http.StatusNotFound, "404", nil)
}
