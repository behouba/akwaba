package website

import (
	"log"
	"net/http"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) handleLogin(c *gin.Context) {
	var cust akwaba.Customer
	if err := c.ShouldBindJSON(&cust); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"user":    cust,
			"message": "Adresse e-mail ou mot de passe invalide",
		})
		return
	}

	cust, err := h.auth.Authenticate(cust.Email, cust.Password)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"user":    cust,
			"message": "Adresse e-mail ou mot de passe invalide",
		})
		return
	}

	saveSessionUser(&cust, c)
	c.JSON(http.StatusOK, gin.H{
		"user":    cust,
		"message": "connection effectuée avec succès",
	})
}

func (h *Handler) registration(c *gin.Context) {
	c.HTML(http.StatusOK, "registration", gin.H{})
}

func (h *Handler) handleRegistration(c *gin.Context) {
	var data akwaba.Customer
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"data": data,
		})
	}
	log.Println(data)

	cust, err := h.customerStore.Save(&data)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"data":    data,
			"message": err.Error(),
		})
		return
	}
	go h.mailer.WelcomeEmail(&cust)
	saveSessionUser(&cust, c)
	c.JSON(http.StatusOK, gin.H{
		"user": cust,
	})
}

func (h *Handler) recovery(c *gin.Context) {
	c.HTML(http.StatusOK, "recovery", gin.H{})
}

func (h *Handler) handleRecovery(c *gin.Context) {
	email := c.Query("email")
	cust, err := h.customerStore.CustomerByEmail(email)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"email":   email,
			"message": "L'email saisi est inconnu",
		})
		return
	}
	go func() {
		token, err := h.auth.SetRecoveryToken(cust.Email)
		if err != nil {
			log.Println(err)
		}
		err = h.mailer.ResetPasswordEmail(&cust, token)
		if err != nil {
			log.Println(err)
		}
	}()

	c.JSON(http.StatusOK, gin.H{
		"email": cust.Email,
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
