package userapi

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi"
	"github.com/gin-gonic/gin"
)

func (h *Handler) createOrder(c *gin.Context) {
	var order dsapi.Order
	if err := c.ShouldBind(&order); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"messsage": err.Error(),
		})
		return
	}

	if err := order.ValidateData(); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"messsage": err.Error(),
		})
		return
	}
	if err := h.Db.SaveOrder(&order); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"messsage": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"messsage": "order created succesfully" + fmt.Sprintf("order : %v", order),
	})
	// way to tell admin server that new order is created
}

func (h *Handler) cancelOrder(c *gin.Context) {
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	userID := c.GetInt("userID")

	if err := h.Db.CancelOrder(userID, orderID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	// way to tell admin server that order is canceled

}

func (h *Handler) computeOrderCost(c *gin.Context) {
	// will need order's weight packing type distance in km and paymentType
	// need more info and service to be properly implemented
	origin := c.Query("origin")
	destination := c.Query("destination")
	weight, err := strconv.ParseFloat(c.Query("weight"), 64)
	if err != nil || weight == 0 {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Pas suffisamement d'information pour calculer le cout de la livraison",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":     "Voici une estimation du cout de votre commande",
		"origin":      origin,
		"destination": destination,
		"weight":      weight,
		"price":       1500 * weight,
	})
}

func (h *Handler) trackOrder(c *gin.Context) {
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	userID := c.GetInt("userID")
	oTrace, err := h.Db.Track(userID, orderID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"response": oTrace,
	})
}

func (h *Handler) allOrders(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"orders": []dsapi.Order{},
	})
}
