package api

import (
	"fmt"
	"log"
	"net/http"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/web/mail"
	"github.com/behouba/akwaba/web/session"
	"github.com/gin-gonic/gin"
)

/* ---API--- */
func (h *handler) handleLogin(c *gin.Context) {

	data := struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}{}

	err := c.ShouldBindJSON(&data)
	if err != nil {
		log.Println(err)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	user, err := h.accountStore.Authenticate(c, data.Email, data.Password, c.ClientIP())
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}

	token, err := h.authenticator.NewToken(&user)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user":  user,
	})
}

func (h *handler) handleRegistration(c *gin.Context) {
	var user akwaba.User

	err := c.ShouldBindJSON(&user)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	err = h.accountStore.Save(c, &user)
	if err != nil {
		log.Println("has error", err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	token, err := h.authenticator.NewToken(&user)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user":  user,
	})
}

func (h *handler) handleRecovery(c *gin.Context) {
	email := c.Query("email")
	user, err := h.accountStore.UserByEmail(c, email)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	token, err := h.accountStore.SetRecoveryToken(c, user.Email)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	log.Println(token)
	// use token to send request to notifier server.
	go func() {
		mail.SendRecoveryEmail(c, email, token)
	}()
	c.JSON(http.StatusOK, gin.H{
		"email": user.Email,
	})
}

func (h *handler) handleChangePassword(c *gin.Context) {
	data := struct {
		Token       string `json:"token"`
		NewPassword string `json:"newPassword"`
	}{}
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	if len(data.NewPassword) < 4 || len(data.Token) < 1 {
		c.JSON(http.StatusBadRequest, nil)
		return
	}
	userID, err := h.accountStore.CheckRecoveryToken(c, data.Token)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Ce lien de récuperation n'est plus valide ou n'existe pas",
		})
		return
	}

	err = h.accountStore.SaveNewPassword(c, userID, data.Token, data.NewPassword)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Votre mot de passe est maintenant réinitialisé avec succès",
	})
}

func (h *handler) jwtAuthRequired(c *gin.Context) {
	user := session.GetContextUser(c, h.authenticator)
	fmt.Println(user.ID)
	if &user == nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": "L'access à cet API ne vous est pas authorisé.",
		})
		return
	}

	c.Next()
}

func (h *handler) nonJWTAuthenticated(c *gin.Context) {
	user := session.GetContextUser(c, h.authenticator)
	if user.ID != 0 {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"message": "Vous êtes déja authentifié.",
		})
		return
	}
	c.Next()
}
