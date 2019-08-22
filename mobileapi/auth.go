package mobileapi

import (
	"fmt"
	"log"
	"net/http"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func sendWelcomeEmail(firstName, email string) (err error) {
	url := fmt.Sprintf("%s/welcome?first_name=%s&email=%s", akwaba.MailerBaseURL, firstName, email)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func sendRecoveryEmail(email, token string) (err error) {
	url := fmt.Sprintf("%s/recovery?email=%s&token=%s", akwaba.MailerBaseURL, email, token)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func (h *Handler) handleLogin(c *gin.Context) {

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

	user, err := h.auth.Authenticate(data.Email, data.Password, c.ClientIP())
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}

	token, err := h.jwt.NewToken(&user)
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

func (h *Handler) handleRegistration(c *gin.Context) {
	var user akwaba.User

	err := c.ShouldBindJSON(&user)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	err = h.userStore.Save(&user)
	if err != nil {
		log.Println("has error", err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	token, err := h.jwt.NewToken(&user)
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

func (h *Handler) handleRecovery(c *gin.Context) {
	email := c.Query("email")
	user, err := h.userStore.UserByEmail(email)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	token, err := h.auth.SetRecoveryToken(user.Email)
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
		err = sendRecoveryEmail(email, token)
		if err != nil {
			log.Println(err)
		}
		log.Println(err)
	}()
	c.JSON(http.StatusOK, gin.H{
		"email": user.Email,
	})
}

func (h *Handler) handleNewPasswordRequest(c *gin.Context) {
	data := struct {
		Token       string `json:"token"`
		NewPassword string `json:"newPassword"`
	}{}
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}

	if len(data.NewPassword) < 4 || len(data.Token) < 1 {
		c.JSON(http.StatusBadRequest, nil)
		return
	}
	userID, err := h.auth.CheckRecoveryToken(data.Token)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Ce lien de récuperation n'est plus valide ou n'existe pas",
		})
		return
	}

	err = h.auth.UpdatePassword(userID, data.Token, data.NewPassword)
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

func (h *Handler) authRequired(c *gin.Context) {
	user := h.contextUser(c)
	if user.ID == 0 {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": "L'access à cet API ne vous est pas authorisé.",
		})
		return
	}

	c.Next()
}

func (h *Handler) nonAuthenticated(c *gin.Context) {
	user := h.contextUser(c)
	if user.ID != 0 {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"message": "Vous êtes déja authentifié.",
		})
		return
	}
	c.Next()
}
