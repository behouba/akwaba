package website

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

func (h *Handler) orderForm(c *gin.Context) {
	categoryID, _ := strconv.Atoi(c.Query("categoryId"))

	c.HTML(http.StatusOK, "order-form", gin.H{
		"user":           sessionUser(c),
		"origin":         c.Query("origin"),
		"destination":    c.Query("destination"),
		"categoryName":   h.shipmentCategories[uint8(categoryID)],
		"categoryID":     categoryID,
		"paymentOptions": h.paymentOptions,
	})
}

func (h *Handler) handleOrderCreation(c *gin.Context) {
	var order akwaba.Order
	user := sessionUser(c)

	if err := c.ShouldBindJSON(&order); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		log.Println(err)
		return
	}
	log.Println(order)

	order.UserID = user.ID
	err := h.orderStore.Save(&order)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
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

func (h *Handler) orderSuccess(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Query("orderId"), 10, 64)
	if err != nil {
		log.Println(err)
		// c.Redirect(http.StatusSeeOther, "/")
		return
	}
	user := sessionUser(c)
	order, err := h.orderStore.Order(orderID, user.ID)
	if err != nil {
		log.Println(err)
		c.Redirect(http.StatusTemporaryRedirect, "/")
	}
	if order.State.ID != akwaba.OrderStatePendingID {
		c.Redirect(http.StatusTemporaryRedirect, "/")
	}
	c.HTML(http.StatusOK, "order-created", gin.H{
		"orderId": orderID,
	})
}

func (h *Handler) cancelOrder(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Param("orderId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	user := sessionUser(c)
	order, err := h.orderStore.Order(orderID, user.ID)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": err.Error(),
		})
		return
	}
	if order.State.ID != akwaba.OrderStatePendingID {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Impossible d'annuler cette commande",
		})
		return
	}
	err = h.orderStore.Cancel(orderID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Commande annulée avec succès"),
	})
}
