package site

import (
	"log"
	"net/http"

	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
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
	session := sessions.Default(c)

	var user akwaba.User
	user.FullName = c.PostForm("name")
	user.Email = c.PostForm("email")
	user.Phone = c.PostForm("phone")
	user.Password = c.PostForm("password")

	newUser, status, err := h.Db.SaveNewCustomer(&user)
	if err != nil {
		log.Println(err)
		c.HTML(status, "registration", gin.H{
			"user":  user,
			"error": err.Error(),
		})
		return
	}

	session.Set("id", newUser.ID)
	session.Set("name", newUser.FullName)
	session.Save()

	c.Redirect(302, "/")
}

func (h *Handler) handleLogin(c *gin.Context) {
	session := sessions.Default(c)

	user, err := h.Db.Authenticate(c.PostForm("email"), c.PostForm("password"))
	if err != nil {
		log.Println(err)
		c.HTML(500, "login", gin.H{
			"user":  user,
			"error": "Adresse e-mail ou mot de passe invalide",
		})
		return
	}
	session.Set("id", user.ID)
	session.Set("name", user.FullName)
	session.Save()
	c.Redirect(302, "/")
}

func (h *Handler) logout(c *gin.Context) {
	session := sessions.Default(c)
	session.Delete("id")
	session.Delete("name")
	session.Save()
	c.Redirect(302, "/")
}

func (h *Handler) handleRecovery(c *gin.Context) {
	email := c.PostForm("email")
	user, err := h.Db.GetUserByEmail(email)
	if err != nil {
		c.HTML(500, "recovery", gin.H{
			"email": email,
			"error": "L'email saisi est inconnu",
		})
		return
	}
	newUUID, err := h.Db.SavePasswordRecoveryRequest(&user)
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
	_, err := h.Db.CheckPasswordChangeRequestUUID(uuid)
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
	userID, err := h.Db.CheckPasswordChangeRequestUUID(uuid)
	if err != nil {
		c.HTML(http.StatusOK, "recovery-exp", gin.H{
			"error": "Ce lien de récuperation n'est plus valide ou n'existe pas",
		})
		return
	}

	err = h.Db.ChangePassword(userID, uuid, newPassword)
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

func authRequired() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		userID := session.Get("id")
		if userID == nil {
			// You'd normally redirect to login page
			c.Redirect(302, "/")
			// c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid session token"})
		} else {
			// Continue down the chain to handler etc
			c.Next()
		}
	}
}

func alreadyAuthenticated() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		userID := session.Get("id")
		log.Println("user id", userID)

		if userID != nil {
			c.Redirect(302, "/")
			return
		}
		c.Next()
	}
}

func handleRegistrationError(c *gin.Context) {

}
