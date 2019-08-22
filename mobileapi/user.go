package mobileapi

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
	user := h.contextUser(c)

	orders, err := h.orderStore.Orders(user.ID, offset)
	if err != nil {
		log.Println(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, orders)
}

func (h *Handler) updatePassword(c *gin.Context) {
	password := struct {
		Current string `json:"current"`
		New     string `json:"new"`
	}{}
	err := c.BindJSON(&password)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	user := h.contextUser(c)
	err = h.userStore.UpdatePassword(password.Current, password.New, user.ID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Votre mot de passe a été mis à jour avec succès",
	})
}

func (h *Handler) updateProfile(c *gin.Context) {
	u := h.contextUser(c)
	var user akwaba.User
	if err := c.ShouldBindJSON(&user); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if user.ID != u.ID {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": "Vous n'etes pas authorisé a modifier ce profil.",
		})
		return
	}
	err := h.userStore.Update(&user)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	token, err := h.jwt.NewToken(&user)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusOK, gin.H{
			"error": err.Error(),
		})
	}
	c.JSON(http.StatusOK, gin.H{
		"token":   token,
		"user":    user,
		"message": "Votre profil a été mis à jour avec succès",
	})
}

func (h *Handler) profileData(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"user": h.contextUser(c),
	})
}
