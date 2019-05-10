package site

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) home(c *gin.Context) {

	c.HTML(http.StatusOK, "home", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) about(c *gin.Context) {
	c.HTML(http.StatusOK, "about", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) services(c *gin.Context) {
	c.HTML(http.StatusOK, "services", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) tracking(c *gin.Context) {

	c.HTML(http.StatusOK, "tracking", gin.H{
		"user": getSessionUser(c),
	})
}
func (h *Handler) pricing(c *gin.Context) {
	c.HTML(http.StatusOK, "pricing", gin.H{
		"user":            getSessionUser(c),
		"cities":          h.DB.Cities,
		"weightIntervals": h.DB.WeightIntervals,
	})
}

func (h *Handler) conditions(c *gin.Context) {
	c.HTML(http.StatusOK, "conditions", nil)
}

func (h *Handler) privacyPolicy(c *gin.Context) {
	c.HTML(http.StatusOK, "privacy", nil)
}

func (h *Handler) businessContact(c *gin.Context) {
	c.HTML(http.StatusOK, "business", nil)
}
