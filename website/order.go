package website

import (
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) orderForm(c *gin.Context) {
	origin, destination := c.Query("origin"), c.Query("destination")

	shipmentCategoryID, _ := strconv.Atoi(c.Query("shipmentCategoryId"))

	var shipmentCategory akwaba.ShipmentCategory

	if origin == "" || destination == "" || shipmentCategoryID > 3 || shipmentCategoryID < 1 {
		c.Redirect(http.StatusSeeOther, "/order/pricing")
	}

	for _, wi := range h.shipmentCategories {
		if wi.ID == uint8(shipmentCategoryID) {
			shipmentCategory = wi
		}
	}

	c.HTML(http.StatusOK, "order-form", gin.H{
		"user":             sessionUser(c),
		"origin":           origin,
		"destination":      destination,
		"shipmentCategory": shipmentCategory,
		"paymentOptions":   h.paymentOptions,
	})
}

// func (h *Handler) handleOrderCreation(c *gin.Context) {
// 	var order akwaba.Order
// 	user := getSessionUser(c)
// 	// time.Sleep(time.Second * 3)

// 	if err := c.ShouldBindJSON(&order); err != nil {
// 		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
// 			"message": err.Error(),
// 		})
// 		log.Println(err)
// 		return
// 	}

// 	err := order.ValidateData()
// 	if err != nil {
// 		log.Println(err)
// 		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}
// 	if user.ID != 0 {
// 		order.OrderID, err = h.DB.SaveCustomerOrder(&order, user.ID)
// 		if err != nil {
// 			log.Println(err)
// 			return
// 		}
// 	} else {
// 		if user.ID != 0 {
// 			order.CustomerID.Int64 = int64(user.ID)
// 		}
// 		err = h.SaveOrder(&order)
// 		if err != nil {
// 			log.Println(err)
// 			c.JSON(http.StatusInternalServerError, gin.H{
// 				"message": err.Error(),
// 			})
// 			return
// 		}
// 		log.Println(order)
// 		c.JSON(http.StatusOK, gin.H{
// 			"order": order,
// 		})
// 	}

// 	(func(h *Handler) confirmOrder)(c * gin.Context)

// 	if err != nil {
// 		log.Println(err)
// 		c.Redirect(302, "/order/create")
// 		return
// 	}

// 	if user.ID != 0 {
// 		err = h.DB.SaveCustomerOrder(&order, user.ID)
// 		if err != nil {
// 			log.Println(err)
// 			return
// 		}
// 	} else {
// 		err = h.DB.SaveOrder(&order)
// 		if err != nil {
// 			log.Println(err)
// 			return
// 		}
// 	}
// 	c.HTML(http.StatusOK, "order-created", gin.H{
// 		"order": order,
// 	})
// }

// func (h *Handler) orderSuccess(c *gin.Context) {
// 	id, err := strconv.ParseUint(c.Query("orderId"), 10, 64)
// 	if err != nil {
// 		log.Println(err)
// 		// c.Redirect(http.StatusSeeOther, "/")
// 		return
// 	}

// 	c.HTML(http.StatusOK, "order-created", gin.H{
// 		"orderId": id,
// 	})
// }

// func (h *Handler) serveOrderReceipt(c *gin.Context) {
// 	var sender, receiver akwaba.Address
// 	orderID, _ := strconv.ParseUint(c.Param("id"), 10, 64)

// 	order, err := h.DB.GetOrderByID(orderID)
// 	if err != nil {
// 		log.Println(err)
// 		return
// 	}
// 	err = json.Unmarshal(order.Sender, &sender)
// 	if err != nil {
// 		log.Println(err)
// 		return
// 	}
// 	err = json.Unmarshal(order.Receiver, &receiver)
// 	if err != nil {
// 		log.Println(err)
// 		return
// 	}
// 	c.HTML(http.StatusOK, "order-invoice", gin.H{
// 		"order":    order,
// 		"sender":   sender,
// 		"receiver": receiver,
// 	})
// }

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
