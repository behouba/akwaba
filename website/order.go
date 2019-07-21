package website

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

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
	cust := sessionUser(c)

	if err := c.ShouldBindJSON(&order); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		log.Println(err)
		return
	}
	log.Println(order)

	order.CustomerID = cust.ID
	err := h.orderStore.Save(&order)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"orderId": order.OrderID,
	})

}

func (h *Handler) orderSuccess(c *gin.Context) {
	id, err := strconv.ParseUint(c.Query("orderId"), 10, 64)
	if err != nil {
		log.Println(err)
		// c.Redirect(http.StatusSeeOther, "/")
		return
	}

	c.HTML(http.StatusOK, "order-created", gin.H{
		"orderId": id,
	})
}

func (h *Handler) orderInfo(c *gin.Context) {
	// var shipment []akwaba.Shipment
	orderID, _ := strconv.ParseUint(c.Param("id"), 10, 64)

	order, err := h.orderStore.ByID(orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusOK, gin.H{
			"message": err.Error(),
		})
		return
	}
	// err = json.Unmarshal(order.Shipments, &shipment)
	// if err != nil {
	// 	log.Println(err)
	// 	return
	// }
	// c.JSON(http.StatusOK, gin.H{
	// 	"order": order,
	// })
	c.JSON(http.StatusOK, gin.H{
		"order": order,
	})
}

// func (h *Handler) cancelOrder(c *gin.Context) {
// 	orderID, err := strconv.ParseUint(c.Param("id"), 10, 64)
// 	if err != nil {
// 		c.AbortWithStatusJSON(
// 			http.StatusInternalServerError,
// 			gin.H{
// 				"message": err.Error(),
// 			})
// 		return
// 	}
// 	user := getSessionUser(c)

// 	canceledID, err := h.DB.CancelOrder(orderID, user.ID)
// 	if err != nil {
// 		c.AbortWithStatusJSON(
// 			http.StatusInternalServerError,
// 			gin.H{
// 				"message": err.Error(),
// 			})
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"message": fmt.Sprintf("Commande %d annulé avec succès", canceledID),
// 	})
// }
