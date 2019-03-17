package adminapi

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi"
	"github.com/gin-gonic/gin"
)

func (h *Handler) createOrder(c *gin.Context) {
	var order dsapi.Order
	if err := c.ShouldBindJSON(&order); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err,
		})
		return
	}

	if err := h.Db.SaveOrder(&order); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err,
		})
		return
	}

}

// pendingOrders retreive and return in json format new orders that belong
// employee area
func (h *Handler) pendingOrders(c *gin.Context) {
	// get employee identification data before retreiving
	// orders pending in his area
	orders, err := h.Db.PendingOrders(5)
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
func (h *Handler) orderInfo(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("orderId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	order, err := h.Db.Order(id)
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

func (h *Handler) confirmOrder(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("orderId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if err := h.Db.ConfirmOrder(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a bien été confirmée", id),
	})
}

func (h *Handler) cancelOrder(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("orderId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if err := h.Db.CancelOrder(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a bien été annulée", id),
	})
}

func (h *Handler) orderReceipt(c *gin.Context) {

}
