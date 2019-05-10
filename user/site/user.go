package site

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) orders(c *gin.Context) {
	c.HTML(http.StatusOK, "orders", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) settings(c *gin.Context) {
	c.HTML(http.StatusOK, "settings", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) updateProfile(c *gin.Context) {
	c.HTML(http.StatusOK, "settings", gin.H{
		"user":    getSessionUser(c),
		"success": "Votre profil a été mis à jour avec succès",
	})
}
