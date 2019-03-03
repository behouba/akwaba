package handler

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi/internal/customer"
	"github.com/behouba/dsapi/internal/notifier"
	"github.com/behouba/dsapi/internal/platform/jwt"
	"github.com/behouba/dsapi/internal/platform/postgres"
	"github.com/behouba/dsapi/internal/platform/redis"
	"github.com/gin-gonic/gin"
)

const (
	cookieMaxAge = 31557600
)

// User represents the User API methods set
type User struct {
	Db    *postgres.DB
	Cache *redis.Cache
	Auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

// CheckPhone handler phone number verification to see if user is registered or not
func (u *User) CheckPhone(c *gin.Context) {
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
func (u *User) Registration(c *gin.Context) {
	// donnee json a traiter contenant les info sur l'utilisateur
	bs, err := ioutil.ReadAll(c.Request.Body)
	if err != nil {
		c.Status(http.StatusBadRequest)
		return
	}
	newCust, err := customer.ParseCustomerInfo(bs)
	if err != nil {
		c.Status(http.StatusBadRequest)
		return
	}
	userID, err := u.Db.SaveNewCustomer(newCust)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	code, err := u.Sms.SendAuthCode(userID, newCust.Phone)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	err = u.Cache.SaveAuthCode(newCust.Phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + newCust.Phone,
	})
}

// ConfirmPhone handler make validation of customer phone number
func (u *User) ConfirmPhone(c *gin.Context) {
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
func (u *User) CheckAuthState(c *gin.Context) {
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
