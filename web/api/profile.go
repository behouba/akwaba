package api

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/web/session"
	"github.com/gin-gonic/gin"
)

func (h *handler) orders(c *gin.Context) {
	offset, _ := strconv.ParseUint(c.Query("offset"), 10, 64)
	user := session.GetContextUser(c, h.authenticator)

	orders, err := h.orderStore.Orders(c, user.ID, offset)
	if err != nil {
		log.Println(err)
	}
	c.JSON(http.StatusOK, gin.H{
		"orders": orders,
	})
}

func (h *handler) updatePassword(c *gin.Context) {
	password := struct {
		Current string `json:"current"`
		New     string `json:"new"`
	}{}
	err := c.ShouldBind(&password)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	user := session.GetContextUser(c, h.authenticator)
	err = h.accountStore.UpdatePassword(c, user.ID, password.Current, password.New)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"user":    session.GetContextUser(c, h.authenticator),
		"message": "Votre mot de passe a été mis à jour avec succès",
	})
}

func (h *handler) updateProfile(c *gin.Context) {
	u := session.GetContextUser(c, h.authenticator)
	var user akwaba.User

	if err := c.ShouldBindJSON(&user); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"user":    session.GetContextUser(c, h.authenticator),
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
	err := h.accountStore.UpdateUserInfo(c, &user)
	if err != nil {
		log.Println(err)

		c.JSON(http.StatusInternalServerError, gin.H{
			"user":  session.GetContextUser(c, h.authenticator),
			"error": err.Error(),
		})
		return
	}
	sUser := session.GetContextUser(c, h.authenticator)
	if sUser.ID != 0 {
		session.Save(&user, c)
		c.JSON(http.StatusOK, gin.H{
			"user":    session.GetContextUser(c, h.authenticator),
			"message": "Votre profil a été mis à jour avec succès",
		})
		return
	}

	token, err := h.authenticator.NewToken(&user)
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

func (h *handler) profileData(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"user": session.GetContextUser(c, h.authenticator),
	})
}
