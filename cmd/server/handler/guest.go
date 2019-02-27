package handler

import (
	"io/ioutil"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi/internal/customer"
	"github.com/behouba/dsapi/internal/notifier/sms"
	"github.com/behouba/dsapi/internal/platform/postgres"
	"github.com/behouba/dsapi/internal/platform/redis"
	"github.com/gin-gonic/gin"
)

// checkCustomerPhone handle customer registration/authentification
// first step. We check received phone number in our customer database
// if user is here we send verification sms to phone number
// else we notify that request came from new customer so that client could ask
// supplementary registration information before registration
func checkGuestPhone(c *gin.Context) {
	phone := c.Query("p")

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

	_, err = sms.SendAuthCode(userID, phone)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Sorry we failed to send you authentication sms to :" + phone,
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + phone,
	})
	return
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
		// handle
	}
	newCust, err := customer.ParseCustomerInfo(bs)
	if err != nil {
		c.Status(http.StatusBadRequest)
		return
		// handle
	}
	userID, err := postgres.SaveNewCustomer(newCust)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
		// handle
	}
	code, err := sms.SendAuthCode(userID, newCust.Phone)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
		// handle
	}
	err = redis.SaveAuthCode(userID, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	// return succes response
}

// phoneValidation receive POST request with validation code
// entrered by user. The provided code will be checked against the
// original sent. If match will send json token to user in response
// to remember about him
func phoneValidation(c *gin.Context) {

}
