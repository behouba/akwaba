package handler

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi/internal/customer"
	"github.com/behouba/dsapi/internal/notifier/sms"
	"github.com/behouba/dsapi/internal/platform/jwt"
	"github.com/behouba/dsapi/internal/platform/postgres"
	"github.com/behouba/dsapi/internal/platform/redis"
	"github.com/gin-gonic/gin"
)

const (
	cookieMaxAge = 31557600
)

// checkCustomerPhone handle customer registration/authentification
// first step. We check received phone number in our customer database
// if user is here we send verification sms to phone number
// else we notify that request came from new customer so that client could ask
// supplementary registration information before registration
func checkGuestPhone(c *gin.Context) {
	phone := c.Param("phone")

	// phone number format validation
	_, err := strconv.Atoi(phone)
	if (len(phone) != 8) || (err != nil) {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Invalid phone number",
		})
		return
	}

	userID, err := postgres.CheckPhone(phone)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": phone + " is not yet registered, pleasse register it.",
		})
		return
	}

	code, err := sms.SendAuthCode(userID, phone)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Sorry we failed to send you authentication sms to :" + phone,
		})
		return
	}

	err = redis.SaveAuthCode(phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + phone,
	})
}

// customerRegister receive POST request with json object
// with customer information
// customer information will be validated
// and stored to database
// if all right return status ok
// else will responde will corresponding status error
func registerGuest(c *gin.Context) {
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
	userID, err := postgres.SaveNewCustomer(newCust)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	code, err := sms.SendAuthCode(userID, newCust.Phone)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	err = redis.SaveAuthCode(newCust.Phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
}

// phoneValidation receive POST request with validation code
// entrered by user. The provided code will be checked against the
// original sent. If match will send json token to user in response
// to remember about him
func phoneValidation(c *gin.Context) {
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

	if !redis.ConfirmSMSCode(phone, code) {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Provided code is not correct.",
		})
		return
	}

	customerID, err := postgres.CustomerIDFromPhone(phone)
	if err != nil {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Something went wrong with this request.",
		})
		return
	}

	token, err := jwt.MakeCustomerJWT(customerID)
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

func checkAuthState(c *gin.Context) {
	token, err := c.Cookie("token")
	if token == "" || err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Sorry you are not authenticated.",
		})
		return
	}
	customerID, err := jwt.ValidateJWT(token)
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
