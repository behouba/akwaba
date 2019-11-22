package website

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) userOrdersHTML(c *gin.Context) {
	user := sessionUser(c)
	c.HTML(http.StatusOK, "user-orders", gin.H{
		"user": user,
	})
}

func (h *Handler) updatePasswordHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "update-password", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) settingsHTML(c *gin.Context) {
	log.Println(sessionUser(c))
	c.HTML(http.StatusOK, "settings", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) orders(c *gin.Context) {
	offset, _ := strconv.ParseUint(c.Query("offset"), 10, 64)
	user := h.contextUser(c)

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
	err := c.ShouldBind(&password)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	user := h.contextUser(c)
	err = h.userStore.UpdatePassword(password.Current, password.New, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"user":    sessionUser(c),
		"message": "Votre mot de passe a été mis à jour avec succès",
	})
}

func (h *Handler) updateProfile(c *gin.Context) {
	u := h.contextUser(c)
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
			"user":  sessionUser(c),
			"error": err.Error(),
		})
		return
	}
	sUser := sessionUser(c)
	if sUser.ID != 0 {
		saveSessionUser(&user, c)
		c.JSON(http.StatusOK, gin.H{
			"user":    sessionUser(c),
			"message": "Votre profil a été mis à jour avec succès",
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
