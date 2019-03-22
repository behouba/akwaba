package adminapi

import (
	"database/sql"
	"fmt"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi/adminapi/internal/postgres"

	"github.com/behouba/dsapi"
	"github.com/behouba/dsapi/adminapi/internal/jwt"
	"github.com/behouba/dsapi/adminapi/internal/notifier"
	"github.com/gin-gonic/gin"
)

// UserHandler implement methods sets to handler customer operations
type UserHandler struct {
	Store dsapi.AdminUserManager
	Auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

// NewUserHandler return new UserHandler
func NewUserHandler(db *sql.DB, secret string) *UserHandler {
	return &UserHandler{
		Store: &postgres.UserStore{DB: db},
		Auth:  jwt.NewAdminAuth(secret),
	}
}

func (u *UserHandler) createCustomer(c *gin.Context) {
	var user dsapi.User
	var err error
	err = c.ShouldBindJSON(&user)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	err = user.CheckData()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	user.ID, err = u.Store.SaveUser(&user)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "New customer created successfully",
		"user":    user,
	})
}

func (u *UserHandler) customerData(c *gin.Context) {
	by := c.Query("by")
	q := c.Query("q")
	var err error
	var users []dsapi.User

	if by == "phone" {
		users, err = u.Store.GetUserByPhone(q)
	} else if by == "name" {
		users, err = u.Store.GetUserByName(q)
	}

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"results": users,
	})
}

func (u *UserHandler) freezeCustomer(c *gin.Context) {
	userID, err := strconv.Atoi(c.Param("userId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if err := u.Store.FreezeUser(userID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("L'utilisateur %d a été bloqué temporairement", userID),
	})

}

func (u *UserHandler) unfreezeCustomer(c *gin.Context) {
	userID, err := strconv.Atoi(c.Param("userId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if err := u.Store.UnFreezeUser(userID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("L'utilisateur %d a été debloqué", userID),
	})
}

func (u *UserHandler) getAddresses(c *gin.Context) {
	var addresses []dsapi.Address
	var err error
	addrType := c.Param("type")
	if addrType == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Le type d'adresse n'as pas été specifié",
		})
		return
	}
	userID, err := strconv.Atoi(c.Query("userId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	addresses, err = u.Store.GetAddresses(userID, addrType)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"results": addresses,
	})
}

func (u *UserHandler) createAddress(c *gin.Context) {
	var addr dsapi.Address
	var err error
	err = c.ShouldBindJSON(&addr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	addr.ID, err = u.Store.SaveAddress(&addr)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"address": addr,
	})
}
