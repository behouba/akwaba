package site

import (
	"log"
	"net/http"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) login(c *gin.Context) {
	c.HTML(http.StatusOK, "login", gin.H{})
}

func (h *Handler) registration(c *gin.Context) {
	c.HTML(http.StatusOK, "registration", gin.H{})
}

func (h *Handler) recovery(c *gin.Context) {
	c.HTML(http.StatusOK, "recovery", gin.H{})
}

func (h *Handler) handleRegistration(c *gin.Context) {
	var user akwaba.User
	user.FullName = c.PostForm("name")
	user.Email = c.PostForm("email")
	user.Phone = c.PostForm("phone")
	user.Password = c.PostForm("password")

	newUser, status, err := h.DB.SaveNewCustomer(&user)
	if err != nil {
		log.Println(err)
		c.HTML(status, "registration", gin.H{
			"user":  user,
			"error": err.Error(),
		})
		return
	}

	saveSessionUser(newUser, c)
	c.Redirect(http.StatusSeeOther, "/")
}

func (h *Handler) handleLogin(c *gin.Context) {
	user, err := h.DB.Authenticate(c.PostForm("email"), c.PostForm("password"))
	if err != nil {
		log.Println(err)
		c.HTML(500, "login", gin.H{
			"user":  user,
			"error": "Adresse e-mail ou mot de passe invalide",
		})
		return
	}
	saveSessionUser(&user, c)
	c.Redirect(http.StatusSeeOther, "/")
}

func (h *Handler) logout(c *gin.Context) {
	destroySessionUser(c)
	c.Redirect(http.StatusSeeOther, "/")
}

func (h *Handler) handleRecovery(c *gin.Context) {
	email := c.PostForm("email")
	user, err := h.DB.GetUserByEmail(email)
	if err != nil {
		c.HTML(500, "recovery", gin.H{
			"email": email,
			"error": "L'email saisi est inconnu",
		})
		return
	}
	newUUID, err := h.DB.SavePasswordRecoveryRequest(&user)
	if err != nil {
		c.HTML(500, "recovery", gin.H{
			"error": err.Error(),
		})
		return
	}
	go h.Mailer.SendRecoveryMail(&user, newUUID)

	c.HTML(http.StatusOK, "recovery-s", gin.H{
		"email": user.Email,
	})
}

func (h *Handler) newPasswordRequest(c *gin.Context) {
	uuid := c.Query("uuid")
	_, err := h.DB.CheckPasswordChangeRequestUUID(uuid)
	if err != nil {
		c.HTML(http.StatusOK, "recovery-exp", gin.H{
			"error": "Ce lien de récuperation n'est plus valide ou n'existe pas",
		})
		return
	}
	c.HTML(http.StatusOK, "new-password", gin.H{
		"uuid": uuid,
	})
}

func (h *Handler) handleNewPasswordRequest(c *gin.Context) {
	newPassword := c.PostForm("password")
	uuid := c.Query("uuid")

	if len(newPassword) < 4 || len(uuid) < 1 {
		c.HTML(http.StatusOK, "new-password", nil)
		return
	}
	userID, err := h.DB.CheckPasswordChangeRequestUUID(uuid)
	if err != nil {
		c.HTML(http.StatusOK, "recovery-exp", gin.H{
			"error": "Ce lien de récuperation n'est plus valide ou n'existe pas",
		})
		return
	}

	err = h.DB.ChangePassword(userID, uuid, newPassword)
	if err != nil {
		c.HTML(http.StatusOK, "recovery-exp", gin.H{
			"error": err.Error(),
		})
		return
	}
	c.HTML(http.StatusOK, "pw-changed", gin.H{
		"passwordChanged": true,
	})
}

func authRequired(c *gin.Context) {
	user := getSessionUser(c)
	if user.ID == 0 {
		c.AbortWithStatus(http.StatusUnauthorized)
	} else {
		c.Next()
	}
}

func alreadyAuthenticated(c *gin.Context) {
	user := getSessionUser(c)
	if user.ID != 0 {
		c.Redirect(http.StatusSeeOther, "/")
		return
	}
	c.Next()
}

func handleRegistrationError(c *gin.Context) {

}
