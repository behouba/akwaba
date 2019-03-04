package userapi

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi"
	"github.com/behouba/dsapi/platform/jwt"
	"github.com/behouba/dsapi/platform/notifier"
	"github.com/behouba/dsapi/platform/postgres"
	"github.com/behouba/dsapi/platform/redis"
	"github.com/gin-gonic/gin"
)

var (
	errInvalidPhone       = errors.New("Le numéro de téléphone fourni est invalid")
	errFullNameIsRequired = errors.New("Merci de fournir votre nom complet")
)

const (
	cookieMaxAge = 31557600
)

// Handler represents the API handler methods set
type Handler struct {
	Db    *postgres.UserDB
	Cache *redis.Cache
	Auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

// CheckPhone handler phone number verification to see if user is registered or not
func (u *Handler) checkPhone(c *gin.Context) {
	phone := c.Param("phone")

	// phone number format validation
	_, err := strconv.Atoi(phone)
	if (len(phone) != 8) || (err != nil) {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Invalid phone number",
		})
		return
	}

	userID, err := u.Db.CheckPhone(phone)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": phone + " is not yet registered, pleasse register it.",
		})
		return
	}

	code, err := u.Sms.SendAuthCode(userID, phone)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Sorry we failed to send you authentication sms to :" + phone,
		})
		return
	}

	err = u.Cache.SaveAuthCode(phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + phone,
	})
}

// Registration handler new customer registration
func (u *Handler) registration(c *gin.Context) {
	// donnee json a traiter contenant les info sur l'utilisateur
	bs, err := ioutil.ReadAll(c.Request.Body)
	if err != nil {
		c.Status(http.StatusBadRequest)
		return
	}
	var user dsapi.User
	err = unmarshalUser(bs, &user)
	if err != nil {
		c.Status(http.StatusBadRequest)
		return
	}
	userID, err := u.Db.SaveNewCustomer(&user)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	code, err := u.Sms.SendAuthCode(userID, user.Phone)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	err = u.Cache.SaveAuthCode(user.Phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + user.Phone,
	})
}

// ConfirmPhone handler make validation of customer phone number
func (u *Handler) confirmPhone(c *gin.Context) {
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

	if !u.Cache.ConfirmSMSCode(phone, code) {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Provided code is not correct.",
		})
		return
	}

	customerID, err := u.Db.CustomerIDFromPhone(phone)
	if err != nil {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Something went wrong with this request.",
		})
		return
	}

	token, err := u.Auth.MakeCustomerJWT(customerID)
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

// CheckAuthState handle request to check whenever user is authenticated
func (u *Handler) checkAuthState(c *gin.Context) {
	token, err := c.Cookie("token")
	if token == "" || err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Sorry you are not authenticated.",
		})
		return
	}
	customerID, err := u.Auth.ValidateJWT(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": err.Error(),
			"token":   token,
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Welcome you are authenticated dear customer %d", customerID),
	})
}

// unmarshalUser validate new user information
// before registration
func unmarshalUser(bs []byte, u *dsapi.User) (err error) {
	err = json.Unmarshal(bs, u)
	if err != nil {
		return
	}
	if len(u.Phone) != 8 {
		err = errInvalidPhone
		return
	}
	if _, e := strconv.Atoi(u.Phone); e != nil {
		err = errInvalidPhone
		return
	}
	if u.FirstName == "" || u.LastName == "" {
		err = errFullNameIsRequired
		return
	}
	return
}
