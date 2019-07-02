package adminapi

import (
	"log"
	"net/http"
	"strings"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) login(c *gin.Context) {
	var e akwaba.Employee

	if err := c.ShouldBind(&e); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Mauvais requete de connexion",
		})
		return
	}
	employee, err := h.db.Login(&e)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Login ou mot de passe incorrecte",
		})
		return
	}

	token, err := h.auth.NewToken(&employee)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"admin": employee,
	})

}

func (h *Handler) authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		auth := strings.Split(c.GetHeader("Authorization"), " ")
		if len(auth) < 2 {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"message": "L'access à cet API ne vous est pas authorisé.",
			})
			return
		}
		token := auth[1]
		emp, err := h.auth.AuthenticateToken(token)
		if err != nil {
			log.Println(err)
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"message": "Votre session d'authentification n'est plus active, merci de vous réconnecter au système.",
			})
			return
		}
		log.Println("employee office id: ", emp.Office.ID)
	}
}
