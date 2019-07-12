package adminapi

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// func getEmployee(c *gin.Context, auth *jwt.Authenticator) (emp akwaba.Employee) {
// 	token := strings.Split(c.GetHeader("Authorization"), " ")[1]
// 	emp, _ = auth.AuthenticateToken(token)
// 	return
// }

func (h *HeadOfficeHandler) pendingOrders(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	orders, err := h.orderStore.Pending()
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

// func (h *Handler) ordersToPickUp(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)

// 	orders, err := h.db.PendingOrders(emp.Office.ID)
// 	if err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusBadRequest, gin.H{
// 			"error": err.Error(),
// 		})
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"orders": orders,
// 	})
// }

func (h *HeadOfficeHandler) cancelOrder(c *gin.Context) {
	// emp := getEmployee(c, h.auth)
	orderID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas annulé comme c'est le cas actuellement

	err = h.orderStore.Cancel(orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": fmt.Sprintf(
				`Désolé, une erreur est survenue lors de l'annulation de la commande %d`,
				orderID,
			),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été annulée avec succès", orderID),
	})
}

func (h *HeadOfficeHandler) confirmOrder(c *gin.Context) {
	// emp := getEmployee(c, h.auth)

	orderID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas confirmée comme c'est le cas actuellement

	_, err = h.orderStore.Confirm(orderID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": fmt.Sprintf(
				`Désolé, une erreur est survenue lors de la confirmation de la commande %d`,
				orderID,
			),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été confirmée avec succès", orderID),
	})
}

// func (h *Handler) createOrder(c *gin.Context) {
// 	var order akwaba.Order
// 	if err := c.ShouldBind(&order); err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusBadRequest, gin.H{
// 			"message": "Impossible de traiter cette requête.",
// 		})
// 		return
// 	}

// 	if err := h.orderStore.Create(&order); err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusInternalServerError, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"message": "Nouvelle commande créee avec succès.",
// 		"order":   order,
// 	})
// 	log.Println(order)
// }
