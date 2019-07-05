package website

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) orderForm(c *gin.Context) {
	origin, destination := c.Query("origin"), c.Query("destination")

	categoryID, _ := strconv.Atoi(c.Query("categoryId"))

	cost, _, err := h.calculator.Cost(origin, destination, uint8(categoryID))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Echec de la requête: " + err.Error(),
		})
		return
	}
	categoryName := h.shipmentCategories[uint8(categoryID)]

	c.HTML(http.StatusOK, "order-form", gin.H{
		"user":           sessionUser(c),
		"origin":         origin,
		"cost":           cost,
		"destination":    destination,
		"categoryName":   categoryName,
		"categoryID":     categoryID,
		"paymentOptions": h.paymentOptions,
	})
}

func (h *Handler) handleOrderCreation(c *gin.Context) {
	var shipments []akwaba.Shipment
	cust := sessionUser(c)
	// time.Sleep(time.Second * 3)

	if err := c.ShouldBindJSON(&shipments); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		log.Println(err)
		return
	}
	log.Println(shipments)
	// err := order.ValidateData()
	// if err != nil {
	// 	log.Println(err)
	// 	c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
	// 		"message": err.Error(),
	// 	})
	// 	return
	// }
	for i := 0; i < len(shipments); i++ {
		var err error
		shipments[i].Cost, _, err = h.calculator.Cost(
			shipments[i].Sender.GooglePlace,
			shipments[i].Recipient.GooglePlace,
			shipments[i].Category.ID,
		)
		shipments[i].Category.Name = h.shipmentCategories[shipments[i].Category.ID]
		shipments[i].PaymentOption.Name = h.paymentOptions[shipments[i].PaymentOption.ID]
		if err != nil {
			log.Println(err)
		}
	}
	orderID, err := h.orderStore.Save(shipments, cust.ID)
	if err != nil {
		log.Println(err)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"orderId": orderID,
	})

}

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

func (h *Handler) serveOrderReceipt(c *gin.Context) {
	// var shipment []akwaba.Shipment
	orderID, _ := strconv.ParseUint(c.Param("id"), 10, 64)

	order, err := h.orderStore.OrderByID(orderID)
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
	c.HTML(http.StatusOK, "order-invoice", gin.H{
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
