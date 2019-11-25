package api

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/web/mail"
	"github.com/behouba/akwaba/web/session"
	"github.com/gin-gonic/gin"
)

func (h *handler) handleOrderCreation(c *gin.Context) {
	var order akwaba.Order
	user := session.GetContextUser(c, h.authenticator)

	if err := c.ShouldBindJSON(&order); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		log.Println(err)
		return
	}
	log.Println(order)

	order.UserID = user.ID
	err := h.orderStore.SaveOrder(c, &order)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	go func() {
		err = mail.SendOrderCreationEmail(order.ID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"orderId": order.ID,
	})

}

func (h *handler) cancelOrder(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Param("orderId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	user := session.GetContextUser(c, h.authenticator)
	order, err := h.orderStore.Order(c, orderID, user.ID)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}
	if order.State.ID != akwaba.OrderStatePendingID {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Impossible d'annuler cette commande",
		})
		return
	}
	err = h.orderStore.CancelOrder(c, orderID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Commande annulée avec succès"),
	})
}
