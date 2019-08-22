package head

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func sendOrderConfirmationEmail(orderID uint64) (err error) {
	url := fmt.Sprintf("%s/order/confirmation?id=%d", akwaba.MailerBaseURL, orderID)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func sendOrderCancelationEmail(orderID uint64) (err error) {
	url := fmt.Sprintf("%s/order/cancelation?id=%d", akwaba.MailerBaseURL, orderID)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func (h *Handler) ActiveOrders(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	orders, err := h.orderStore.ActiveOrders()
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	// log.Println("orders: ", orders)
	c.JSON(http.StatusOK, gin.H{
		"orders": orders,
	})
}

func (h *Handler) ClosedOrders(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	date := c.Query("date")
	if date == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "invalid date",
		})
		return
	}
	orders, err := h.orderStore.ClosedOrders(date)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	// log.Println("orders: ", orders)
	c.JSON(http.StatusOK, gin.H{
		"orders": orders,
	})
}

func (h *Handler) CancelOrder(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	orderID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	err = h.orderStore.Cancel(orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.orderStore.UpdateState(orderID, akwaba.OrderStateCanceledID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	go func() {
		sendOrderCancelationEmail(orderID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été annulée avec succès", orderID),
	})
}

func (h *Handler) ConfirmOrder(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}

	_, err = h.orderStore.CreateShipment(orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	_, err = h.orderStore.Confirm(orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.orderStore.UpdateState(orderID, akwaba.OrderInProcessingID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	// Send confirmation email without handling possible errors
	go func() {
		sendOrderConfirmationEmail(orderID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été confirmée avec succès", orderID),
	})
}

func (h *Handler) CreateOrder(c *gin.Context) {
	var order akwaba.Order
	if err := c.ShouldBind(&order); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Impossible de traiter cette requête.",
		})
		return
	}
	err := h.orderStore.Save(&order)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.orderStore.UpdateState(order.ID, akwaba.OrderStatePendingID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Nouvelle commande créee avec succès.",
		"order":   order,
	})
	log.Println(order)
}

func (h *Handler) ComputePrice(c *gin.Context) {
	origin, destination := c.Query("origin"), c.Query("destination")

	categoryID, err := strconv.Atoi(c.Query("categoryId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "La catégorie de colis est requise le calcule des frais de livraison.",
		})
	}
	if origin == "" || destination == "" {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "L'origin et la destination est requise pour le calcule des frais de livraison.",
		})
	}

	cost, distance, err := h.orderStore.Cost(origin, destination, uint8(categoryID))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"cost":     cost,
		"distance": distance,
	})
}
