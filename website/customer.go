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

func (h *Handler) updatePassword(c *gin.Context) {
	password := struct {
		Current string `json:"current"`
		New     string `json:"new"`
	}{}
	err := c.BindJSON(&password)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	user := sessionUser(c)
	err = h.userStore.UpdatePassword(password.Current, password.New, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"user":    sessionUser(c),
		"message": "Votre mot de passe a été mis à jour avec succès",
	})
}

func (h *Handler) updateProfile(c *gin.Context) {
	u := sessionUser(c)
	var user akwaba.User

	if err := c.ShouldBindJSON(&user); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"user":    sessionUser(c),
			"message": err.Error(),
		})
		return
	}
	if user.ID != u.ID {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Vous n'etes pas authorisé a modifier ce profil.",
		})
		return
	}
	log.Println(user)
	err := h.userStore.Update(&user)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"user":    sessionUser(c),
			"message": err.Error(),
		})
		return
	}
	saveSessionUser(&user, c)

	c.JSON(http.StatusOK, gin.H{
		"user":    sessionUser(c),
		"message": "Votre profil a été mis à jour avec succès",
	})
}

func (h *Handler) profileData(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"user": sessionUser(c),
	})
}
