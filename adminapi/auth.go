package adminapi

import (
	"database/sql"
	"net/http"

	"github.com/behouba/akwaba/adminapi/internal/postgres"
	"github.com/behouba/dsapi"

	"github.com/behouba/akwaba/adminapi/internal/jwt"

	"github.com/gin-gonic/gin"
)

// AuthHandler implement methods set that handle request for authentication
type AuthHandler struct {
	Store dsapi.AdminAuthenticator
	Auth  *jwt.Authenticator
}

// NewAuthHandler return new pointer to AuthHandler
func NewAuthHandler(db *sql.DB, jwtSecret string) *AuthHandler {
	return &AuthHandler{
		Store: &postgres.AuthStore{Db: db},
		Auth:  jwt.NewAdminAuth(jwtSecret),
	}
}

func (a *AuthHandler) login(c *gin.Context) {
	var authData dsapi.AdminCredential
	if err := c.ShouldBindJSON(&authData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	emp, err := a.Store.Check(&authData)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}
	token, err := a.Auth.NewJWT(&emp)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.SetCookie("admin_cookie", token, 60, "", "", false, false)
	c.JSON(http.StatusOK, gin.H{
		"token": token,
	})
}

func (a *AuthHandler) logout(c *gin.Context) {

}
