package website

import (
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func sendWelcomeEmail(firstName, email string) (err error) {
	url := fmt.Sprintf("%s/welcome?first_name=%s&email=%s", akwaba.MailerBaseURL, firstName, email)
	_, err = http.Get(url)
	if err != nil {
		return
	}
	return
}

func sendRecoveryEmail(email, token string) (err error) {
	url := fmt.Sprintf("%s/recovery?email=%s&token=%s", akwaba.MailerBaseURL, email, token)
	_, err = http.Get(url)
	if err != nil {
		return
	}
	return
}

func (h *Handler) handleLogin(c *gin.Context) {
	email, password := c.PostForm("email"), c.PostForm("password")

	user, err := h.auth.Authenticate(email, password, c.ClientIP())
	if err != nil {
		log.Println(err)
		c.HTML(http.StatusUnauthorized, "login", gin.H{
			"email":    email,
			"password": password,
			"error":    err.Error(),
		})
		return
	}

	saveSessionUser(&user, c)

	urlParts := strings.Split(c.Request.URL.String(), "redirect=")
	if len(urlParts) > 1 {
		c.Redirect(http.StatusFound, urlParts[1])
		return
	}

	c.Redirect(http.StatusFound, "/")
}

func (h *Handler) registration(c *gin.Context) {
	c.HTML(http.StatusOK, "registration", gin.H{})
}

func (h *Handler) handleRegistration(c *gin.Context) {
	var user akwaba.User
	user.FirstName = c.PostForm("firstName")
	user.LastName = c.PostForm("lastName")
	user.Email = c.PostForm("email")
	user.Phone = c.PostForm("phone")
	user.Password = c.PostForm("password")

	err := h.userStore.Save(&user)
	if err != nil {
		log.Println("has error", err)
		c.HTML(http.StatusOK, "registration", gin.H{
			"user":  user,
			"error": err.Error(),
		})
		return
	}
	// make request to notifier server to send email to user
	saveSessionUser(&user, c)
	urlParts := strings.Split(c.Request.URL.String(), "redirect=")
	if len(urlParts) > 1 {
		c.Redirect(http.StatusFound, urlParts[1])
		return
	}

	go func() {
		err = sendWelcomeEmail(user.FirstName, user.Email)
		if err != nil {
			log.Println(err)
		}
	}()
	c.Redirect(http.StatusFound, "/")
}

func (h *Handler) recovery(c *gin.Context) {
	c.HTML(http.StatusOK, "recovery", gin.H{})
}

func (h *Handler) handleRecovery(c *gin.Context) {
	email := c.Query("email")
	user, err := h.userStore.UserByEmail(email)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"email":   email,
			"message": "L'email saisi est inconnu",
		})
		return
	}
	token, err := h.auth.SetRecoveryToken(user.Email)
	if err != nil {
		log.Println(err)
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

func (h *Handler) newPasswordRequest(c *gin.Context) {
	token := c.Query("token")
	_, err := h.auth.CheckRecoveryToken(token)
	if err != nil {
		log.Println(err)
		c.HTML(http.StatusOK, "recovery-exp", gin.H{
			"error": "Ce lien de récuperation n'est plus valide ou n'existe pas",
		})
		return
	}
	c.HTML(http.StatusOK, "new-password", gin.H{
		"token": token,
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

func authRequired(c *gin.Context) {
	user := sessionUser(c)
	if user.ID == 0 {
		c.Redirect(http.StatusTemporaryRedirect, "/auth/login"+"?redirect="+c.Request.URL.String())
		c.Abort()
		return
	} else {
		c.Next()
	}
}

func alreadyAuthenticated(c *gin.Context) {
	user := sessionUser(c)
	if user.ID != 0 {
		c.Redirect(http.StatusSeeOther, "/")
		return
	}
	c.Next()
}

func handleRegistrationError(c *gin.Context) {

}

func (h *Handler) logout(c *gin.Context) {
	destroySessionUser(c)
	c.Redirect(http.StatusSeeOther, "/")
}
