package adminapi

import (
	"github.com/behouba/dsapi"
	"github.com/behouba/dsapi/adminapi/internal/jwt"
	"github.com/behouba/dsapi/adminapi/internal/notifier"
	"github.com/gin-gonic/gin"
)

// UserHandler implement methods sets to handler customer operations
type UserHandler struct {
	store dsapi.AdminUserManager
	auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

func (h *UserHandler) createNewCustomer(c *gin.Context) {

}

func (h *UserHandler) customerData(c *gin.Context) {

}

func (h *UserHandler) freezeCustomer(c *gin.Context) {

}

func (h *UserHandler) unfreezeCustomer(c *gin.Context) {

}
