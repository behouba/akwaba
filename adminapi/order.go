package adminapi

import (
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

func (h *Handler) pendingOrders(c *gin.Context) {
	orders, err := h.db.Pending(2)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"orders": orders,
	})
}

func (h *Handler) cancelOrder(c *gin.Context) {
	time.Sleep(time.Second * 5)
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas annulé comme c'est le cas actuellement

	// err = h.db.CancelOrder(orderID)
	// if err != nil {
	// 	log.Println(err)
	// 	c.JSON(http.StatusInternalServerError, gin.H{
	// 		"message": fmt.Sprintf(
	// 			`Désolé, une erreur est survenue lors de l'annulation de la commande %d`,
	// 			orderID,
	// 		),
	// 	})
	// 	return
	// }
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été annulée avec succès", orderID),
	})
}

func (h *Handler) confirmOrder(c *gin.Context) {
	time.Sleep(time.Second * 5)
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas confirmée comme c'est le cas actuellement

	// err = h.db.ConfirmOrder(orderID)
	// if err != nil {
	// 	log.Println(err)
	// 	c.JSON(http.StatusInternalServerError, gin.H{
	// 		"message": fmt.Sprintf(
	// 			`Désolé, une erreur est survenue lors de la confirmation de la commande %d`,
	// 			orderID,
	// 		),
	// 	})
	// 	return
	// }
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("La commande %d a été confirmée avec succès", orderID),
	})
}
