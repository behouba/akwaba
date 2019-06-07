package adminapi

import (
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/adminapi/internal/jwt"
	"github.com/gin-gonic/gin"
)

func getEmployee(c *gin.Context, auth *jwt.Authenticator) (emp akwaba.Employee) {
	token := strings.Split(c.GetHeader("Authorization"), " ")[1]
	emp, _ = auth.AuthenticateToken(token)
	return
}

func (h *Handler) pendingOrders(c *gin.Context) {
	emp := getEmployee(c, h.auth)
	orders, err := h.db.ToConfirm(&emp)
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
	emp := getEmployee(c, h.auth)

	orders, err := h.db.ToPickUp(&emp)
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
	emp := getEmployee(c, h.auth)
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas annulé comme c'est le cas actuellement

	err = h.db.CancelOrder(orderID, &emp)
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
	emp := getEmployee(c, h.auth)

	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": fmt.Sprintf("Erreur: Mauvaise requête"),
		})
		return
	}
	// assurer que n'importe commande ne soit pas confirmée comme c'est le cas actuellement

	err = h.db.ConfirmOrder(orderID, &emp)
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
	log.Println(order.PaymentType.ID)

	if err := h.db.CreateOrder(&order); err != nil {
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

func (h *Handler) setCollectedOrders(c *gin.Context) {
	emp := getEmployee(c, h.auth)

	var ids []int

	if err := c.ShouldBind(&ids); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Impossible de traiter cette requête.",
		})
		return
	}
	log.Println(ids)

	h.db.SetCollectedOrders(ids, &emp)

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("%d colis ont étés enregistrés.", len(ids)),
	})
}
