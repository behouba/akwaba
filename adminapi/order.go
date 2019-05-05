package adminapi

import (
	"database/sql"
	"fmt"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba/adminapi/internal/jwt"
	"github.com/behouba/akwaba/adminapi/internal/notifier"
	"github.com/behouba/akwaba/adminapi/internal/postgres"
	"github.com/behouba/dsapi"

	"github.com/gin-gonic/gin"
)

// OrderHandler implement methods set that handle request for order from admin side
type OrderHandler struct {
	Store dsapi.AdminOrderManager
	Auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

// NewOrderHandler initiate a new pointer to OrderHandler
func NewOrderHandler(db *sql.DB, jwtSecretKey string) *OrderHandler {
	auth := jwt.NewAdminAuth(jwtSecretKey)
	return &OrderHandler{
		Store: &postgres.OrderStore{DB: db},
		Auth:  auth,
	}
}

func (o *OrderHandler) createOrder(c *gin.Context) {
	var order dsapi.Order
	var err error
	err = c.ShouldBindJSON(&order)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err,
		})
		return
	}

	order.ID, err = o.Store.Save(&order)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err,
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"resultats": order,
	})
	// after order has been created
}

// pendingOrders retreive and return in json format new orders that belong
// employee area
func (o *OrderHandler) pendingOrders(c *gin.Context) {
	// get employee identification data before retreiving
	// orders pending in his area
	orders, err := o.Store.Pending(2)
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

// getOrder retreive order corresponding to given id
// and return it in json format
func (o *OrderHandler) getOrder(c *gin.Context) {
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
