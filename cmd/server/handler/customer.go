package handler

import (
	"io/ioutil"

	"net/http"

	cust "github.com/behouba/dsapi/internal/customer"
	"github.com/behouba/dsapi/internal/notifier/sms"
	"github.com/behouba/dsapi/internal/platform/postgres"
	"github.com/gin-gonic/gin"
)

// customerRegister receive POST request with json object
// with customer information
// customer information will be validated
// and stored to database
// if all right return status ok
// else will responde will corresponding status error
func registerCustomer(c *gin.Context) {
	// donnee json a traiter contenant les info sur l'utilisateur
	bs, err := ioutil.ReadAll(c.Request.Body)
	if err != nil {
		c.Status(http.StatusBadRequest)
		return
		// handle
	}
	newCust, err := cust.ParseCustomerInfo(bs)
	if err != nil {
		c.Status(http.StatusBadRequest)
		return
		// handle
	}
	err = postgres.SaveNewCustomer(newCust)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
		// handle
	}
	err = sms.SendAuthCode(newCust.Phone)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
		// handle
	}
	// return succes response
}

// phoneValidation receive POST request with validation code
// entrered by user. The provided code will be checked against the
// original sent. If match will send json token to user in response
// to remember about him
func phoneValidation(c *gin.Context) {

}

// cutomerLogout receive POST request without data
// will then remove the access token for current user
func customerLogout(c *gin.Context) {

}

func createNewOrder(c *gin.Context) {

}

func computePrice(c *gin.Context) {

}

func cancelOrder(c *gin.Context) {

}

func trackOrder(c *gin.Context) {

}

func fetchAllOrders(c *gin.Context) {

}

func fetchSupportMsg(c *gin.Context) {

}

func sendMsgToSupport(c *gin.Context) {

}
