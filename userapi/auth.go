package userapi

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi"
	"github.com/behouba/dsapi/userapi/internal/jwt"
	"github.com/behouba/dsapi/userapi/internal/notifier"
	"github.com/behouba/dsapi/userapi/internal/postgres"
	"github.com/gin-gonic/gin"
)

const (
	cookieMaxAge = 31557600
)

// Handler represents the API handler methods set
type Handler struct {
	Db   *postgres.UserDB
	Auth *jwt.Authenticator
	Sms  *notifier.SMS
}

// CheckPhone handler phone number verification to see if user is registered or not
func (h *Handler) checkPhone(c *gin.Context) {
	phone := c.Param("phone")

	// phone number format validation
	_, err := strconv.Atoi(phone)
	if (len(phone) != 8) || (err != nil) {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Invalid phone number",
		})
		return
	}

	userID, err := h.Db.CheckPhone(phone)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": phone + " is not yet registered, pleasse register it.",
		})
		return
	}

	code, err := h.Sms.SendAuthCode(userID, phone)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Sorry we failed to send you authentication sms to :" + phone,
		})
		return
	}

	err = h.Db.SaveAuthCode(phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + phone,
	})
}

// Registration handler new customer registration
func (h *Handler) registration(c *gin.Context) {
	// donnee json a traiter contenant les info sur l'utilisateur
	var user dsapi.User

	if err := c.ShouldBind(&user); err != nil {
		c.Status(http.StatusBadRequest)
		return
	}
	if err := user.CheckNewUserData(); err != nil {
		c.Status(http.StatusBadRequest)
		return
	}
	userID, err := h.Db.SaveNewCustomer(&user)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	code, err := h.Sms.SendAuthCode(userID, user.Phone)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	err = h.Db.SaveAuthCode(user.Phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + user.Phone,
	})
}

// ConfirmPhone handler make validation of customer phone number
func (h *Handler) confirmPhone(c *gin.Context) {
	code := c.Query("code")
	phone := c.Param("phone")

	_, err := strconv.Atoi(phone)
	log.Println(code, phone)
	if len(code) != 4 || len(phone) != 8 || err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Invalid request format",
		})
		if err != nil {
			log.Println(err)
		}
		return
	}

	if !h.Db.ConfirmSMSCode(phone, code) {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Provided code is not correct.",
		})
		return
	}

	customerID, err := h.Db.CustomerIDFromPhone(phone)
	if err != nil {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Something went wrong with this request.",
		})
		return
	}

	token, err := h.Auth.MakeCustomerJWT(customerID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Something went wrong with this request.",
		})
		return
	}
	// Then send access token to customer and store it to postgresql database

	c.SetCookie("token", token, cookieMaxAge, "/", "", false, false)
	c.JSON(http.StatusOK, gin.H{
		"message": "Verification done",
		"token":   token,
	})

}

func (h *Handler) authRequired(c *gin.Context) {
	token, err := c.Cookie("token")
	if token == "" || err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Sorry you are not authenticated.",
		})
		c.Abort()
		return
	}
	userID, err := h.Auth.ValidateJWT(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": err.Error(),
			"token":   token,
		})
		c.Abort()
		return
	}
	c.Set("userID", userID)
}

func (h *Handler) setAuthState(c *gin.Context) {
	token, err := c.Cookie("token")
	if token == "" || err != nil {
		return
	}
	userID, err := h.Auth.ValidateJWT(token)
	if err != nil {
		return
	}
	c.Set("userID", userID)
}
