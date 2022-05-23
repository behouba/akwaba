package site

import (
	"log"
	"net/http"
	"strings"

	"github.com/behouba/akwaba/web/session"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/mail"
	"github.com/gin-gonic/gin"
)

/* ---HTML--- */
func (h *handler) loginHTML(c *gin.Context) {
	_, isRedirect := c.GetQuery("redirect")

	log.Println(isRedirect)
	c.HTML(http.StatusOK, "login", gin.H{
		"isRedirect": isRedirect,
	})
}

func (h *handler) handleLoginForm(c *gin.Context) {
	email, password := c.PostForm("email"), c.PostForm("password")

	user, err := h.accountStore.Authenticate(c, email, password, c.ClientIP())
	if err != nil {
		log.Println(err)
		c.HTML(http.StatusUnauthorized, "login", gin.H{
			"email":    email,
			"password": password,
			"error":    err.Error(),
		})
		return
	}

	session.Save(&user, c)

	urlParts := strings.Split(c.Request.URL.String(), "redirect=")
	if len(urlParts) > 1 {
		c.Redirect(http.StatusFound, urlParts[1])
		return
	}

	c.Redirect(http.StatusFound, "/")
}

func (h *handler) registrationHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "registration", gin.H{})
}

func (h *handler) handleRegistrationForm(c *gin.Context) {
	var user akwaba.User
	user.FirstName = c.PostForm("firstName")
	user.LastName = c.PostForm("lastName")
	user.Email = c.PostForm("email")
	user.Phone = c.PostForm("phone")
	user.Password = c.PostForm("password")

	err := h.accountStore.Save(c, &user)
	if err != nil {
		log.Println("has error", err)
		c.HTML(http.StatusOK, "registration", gin.H{
			"user":  user,
			"error": err.Error(),
		})
		return
	}
	// make request to notifier server to send email to user
	session.Save(&user, c)
	urlParts := strings.Split(c.Request.URL.String(), "redirect=")
	if len(urlParts) > 1 {
		c.Redirect(http.StatusFound, urlParts[1])
		return
	}

	go func() {
		err = mail.SendWelcomeEmail(c, user.FirstName, user.Email)
		if err != nil {
			log.Println(err)
		}
	}()
	c.Redirect(http.StatusFound, "/")
}

func (h *handler) recoveryHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "recovery", gin.H{})
}

func (h *handler) changePasswordHTML(c *gin.Context) {
	token := c.Query("token")
	_, err := h.accountStore.CheckRecoveryToken(c, token)
	if err != nil {
		log.Println(err)
		c.HTML(http.StatusOK, "recovery-exp", gin.H{
			"error": "Ce lien de récuperation n'est plus valide ou n'existe pas",
		})
		return
	}
	c.HTML(http.StatusOK, "change-password", gin.H{
		"token": token,
	})
}

func (h *handler) authRequired(c *gin.Context) {
	user := session.GetWebsiteUser(c)
	if user.ID == 0 {
		c.Redirect(http.StatusTemporaryRedirect, "/auth/login"+"?redirect="+c.Request.URL.String())
		c.Abort()
		return
	}
	c.Next()
}

func (h *handler) alreadyAuthenticated(c *gin.Context) {
	user := session.GetWebsiteUser(c)
	if user.ID != 0 {
		c.Redirect(http.StatusSeeOther, "/")
		return
	}
	c.Next()
}

func handleRegistrationError(c *gin.Context) {

}

func (h *handler) logout(c *gin.Context) {
	session.Destroy(c)
	c.Redirect(http.StatusSeeOther, "/")
}
