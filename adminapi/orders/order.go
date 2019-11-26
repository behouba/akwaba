package orders

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba/mail"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *handler) ActiveOrders(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	orders, err := h.orderStore.ActiveOrders(c)
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

func (h *handler) ClosedOrders(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	date := c.Query("date")
	if date == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "invalid date",
		})
		return
	}
	orders, err := h.orderStore.ClosedOrders(c, date)
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

func (h *handler) CancelOrder(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	orderID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	err = h.orderStore.CancelOrder(c, orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.orderStore.UpdateState(c, orderID, akwaba.OrderStateCanceledID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	go func() {
		mail.SendOrderCancelationEmail(orderID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été annulée avec succès", orderID),
	})
}

func (h *handler) ConfirmOrder(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}

	_, err = h.orderStore.CreateShipment(c, orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	_, err = h.orderStore.ConfirmOrder(c, orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.orderStore.UpdateState(c, orderID, akwaba.OrderInProcessingID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	// Send confirmation email without handling possible errors
	go func() {
		mail.SendOrderConfirmationEmail(orderID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été confirmée avec succès", orderID),
	})
}

func (h *handler) CreateOrder(c *gin.Context) {
	var order akwaba.Order
	var err error
	if err := c.ShouldBind(&order); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Impossible de traiter cette requête.",
		})
		return
	}
	// Set areas id and recompute shipping cost
	err = h.locationService.SetAreaID(c, order.Sender.Area.Name, &order.Sender.Area.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.locationService.SetAreaID(c, order.Recipient.Area.Name, &order.Recipient.Area.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	order.Cost, order.Distance, err = h.pricingService.Cost(
		c, order.Category.ID, order.Sender.Area.Name, order.Recipient.Area.Name,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	err = h.orderStore.SaveOrder(c, &order)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.orderStore.UpdateState(c, order.ID, akwaba.OrderStatePendingID)
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

func (h *handler) ComputePrice(c *gin.Context) {
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

	cost, distance, err := h.pricingService.Cost(c, uint8(categoryID), origin, destination)
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
