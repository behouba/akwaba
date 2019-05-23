package adminapi

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) ordersToConfirm(c *gin.Context) {
	orders, err := h.db.ToConfirm(2)
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

func (h *Handler) ordersToPickUp(c *gin.Context) {
	orders, err := h.db.ToPickUp(2)
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
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas annulé comme c'est le cas actuellement

	err = h.db.CancelOrder(orderID)
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

func (h *Handler) confirmOrder(c *gin.Context) {
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas confirmée comme c'est le cas actuellement

	err = h.db.ConfirmOrder(orderID)
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

func (h *Handler) createOrder(c *gin.Context) {
	var order akwaba.Order
	if err := c.ShouldBind(&order); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Impossible de traiter cette requête.",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Nouvelle commande créee avec succès.",
	})
	log.Println(order)
}
