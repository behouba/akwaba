package adminapi

import (
	"fmt"
	"log"
	"net/http"
	"net/url"

	"github.com/gin-gonic/gin"
)

func (h *Handler) userContact(c *gin.Context) {
	phone := c.Query("phone")
	contact, err := h.db.Contact(phone)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusNotFound, gin.H{
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"contact": contact,
	})
}

func (h *Handler) lockContact(c *gin.Context) {
	phone, _ := url.PathUnescape(c.Query("phone"))
	log.Println(phone)
	err := h.db.LockUser(phone)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Le numéro %s a été bloqué.", phone),
	})
}

func (h *Handler) unlockContact(c *gin.Context) {
	phone, _ := url.PathUnescape(c.Query("phone"))
	log.Println(phone)
	err := h.db.UnlockUser(phone)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Le numéro %s a été debloqué.", phone),
	})
}
