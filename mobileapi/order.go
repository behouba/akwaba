package mobileapi

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func sendOrderCreationEmail(orderID uint64) (err error) {
	url := fmt.Sprintf("%s/order/creation?id=%d", akwaba.MailerBaseURL, orderID)
	_, err = http.Get(url)
	return
}

func (h *Handler) handleOrderCreation(c *gin.Context) {
	var order akwaba.Order
	user := h.contextUser(c)

	if err := c.ShouldBindJSON(&order); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		log.Println(err)
		return
	}
	log.Println(order)

	order.UserID = user.ID
	err := h.orderStore.Save(&order)
	if err != nil {
		log.Println(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	go func() {
		err = sendOrderCreationEmail(order.ID)
		if err != nil {
			log.Println(err)
		}
	}()
	c.JSON(http.StatusOK, gin.H{
		"orderId": order.ID,
	})

}

func (h *Handler) cancelOrder(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	user := h.contextUser(c)
	order, err := h.orderStore.Order(orderID, user.ID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}
	if order.State.ID != akwaba.OrderStatePendingID {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": "Impossible d'annuler cette commande",
		})
		return
	}
	err = h.orderStore.Cancel(orderID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Commande annulée avec succès"),
	})
}
