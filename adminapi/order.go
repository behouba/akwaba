package adminapi

import (
	"database/sql"
	"fmt"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi/adminapi/internal/jwt"
	"github.com/behouba/dsapi/adminapi/internal/notifier"
	"github.com/behouba/dsapi/adminapi/internal/postgres"

	"github.com/behouba/dsapi"
	"github.com/gin-gonic/gin"
)

// OrderHandler implement methods set that handle request for order from admin side
type OrderHandler struct {
	Store dsapi.AdminOrderer
	Auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

// NewOrderHandler initiate a new pointer to OrderHandler
func NewOrderHandler(db *sql.DB, jwtSecretKey string) *OrderHandler {

	auth := jwt.NewAdminAuth(jwtSecretKey)

	sms := notifier.NewSMS()

	return &OrderHandler{
		Store: &postgres.OrderStore{Db: db},
		Auth:  auth,
		Sms:   sms,
	}
}

func (o *OrderHandler) createOrder(c *gin.Context) {
	var order dsapi.Order
	if err := c.ShouldBindJSON(&order); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err,
		})
		return
	}

	if err := o.Store.Save(&order); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err,
		})
		return
	}

}

// pendingOrders retreive and return in json format new orders that belong
// employee area
func (o *OrderHandler) pendingOrders(c *gin.Context) {
	// get employee identification data before retreiving
	// orders pending in his area
	orders, err := o.Store.Pending(5)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"orders": orders,
	})
}

// orderInfo retreive order corresponding to given id
// and return it in json format
func (o *OrderHandler) orderInfo(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("orderId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	order, err := o.Store.Get(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"order": order,
	})
}

func (o *OrderHandler) confirmOrder(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("orderId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if err := o.Store.Confirm(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a bien été confirmée", id),
	})
}

func (o *OrderHandler) cancelOrder(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("orderId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if err := o.Store.Cancel(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a bien été annulée", id),
	})
}

func (o *OrderHandler) orderReceipt(c *gin.Context) {

}
