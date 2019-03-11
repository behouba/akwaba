package adminapi

import (
	"net/http"

	"github.com/behouba/dsapi"
	"github.com/gin-gonic/gin"
)

func (h *Handler) login(c *gin.Context) {
	var authData dsapi.EmployeeAuthData
	if err := c.ShouldBindJSON(&authData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	emp, err := h.Db.CheckCredential(&authData)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}
	token, err := h.Auth.NewJWT(emp)
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

func (h *Handler) logout(c *gin.Context) {

}
