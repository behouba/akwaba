package website

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

// func (h *Handler) handleContact(c *gin.Context) {
// 	name := c.PostForm("name")
// 	phone := c.PostForm("phone")
// 	email := c.PostForm("email")
// 	message := c.PostForm("message")

// 	log.Println(name, phone, email, message)
// }

func (h *Handler) orders(c *gin.Context) {
	offset, _ := strconv.ParseUint(c.Query("offset"), 10, 64)
	user := sessionUser(c)

	orders, err := h.orderStore.Orders(user.ID, offset)
	if err != nil {
		log.Println(err)
	}
	c.JSON(http.StatusOK, gin.H{
		"orders": orders,
	})
}

func (h *Handler) updateProfile(c *gin.Context) {
	user := sessionUser(c)
	var data akwaba.Customer

	if err := c.ShouldBindJSON(&data); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"user":    sessionUser(c),
			"message": err.Error(),
		})
		return
	}
	if data.ID != user.ID {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "You are not allowed to update with profile.",
		})
		return
	}
	log.Println(data)
	err := h.customerStore.UpdateInfo(&data)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"user":    sessionUser(c),
			"message": err.Error(),
		})
		return
	}
	saveSessionUser(&data, c)

	c.JSON(http.StatusOK, gin.H{
		"user":    sessionUser(c),
		"message": "Votre profil a été mis à jour avec succès",
	})
}

func (h *Handler) profileData(c *gin.Context) {
	user := sessionUser(c)
	c.JSON(http.StatusOK, gin.H{
		"user": user,
	})
}
