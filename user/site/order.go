package site

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/jung-kurt/gofpdf"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func orderFromForm(c *gin.Context) (order akwaba.Order) {
	order.Sender.City.ID, _ = strconv.Atoi(c.PostForm("senderCityId"))
	order.PaymentType.ID, _ = strconv.Atoi(c.PostForm("paymentTypeId"))
	order.WeightInterval.ID, _ = strconv.Atoi(c.PostForm("weightIntervalId"))
	order.Sender.FullName = c.PostForm("senderName")
	order.Sender.Phone = c.PostForm("senderPhone")
	order.Sender.Address = c.PostForm("senderAddress")
	order.Receiver.FullName = c.PostForm("receiverName")
	order.Receiver.Phone = c.PostForm("receiverPhone")
	order.Receiver.City.ID, _ = strconv.Atoi(c.PostForm("receiverCityId"))
	order.Receiver.Address = c.PostForm("receiverAddress")
	order.Nature = c.PostForm("nature")
	order.Note = c.PostForm("note")
	return
}

func (h *Handler) order(c *gin.Context) {
	c.HTML(http.StatusOK, "order", gin.H{
		"user":            getSessionUser(c),
		"cities":          h.DB.Cities,
		"weightIntervals": h.DB.WeightIntervals,
		"paymentTypes":    h.DB.PaymentTypes,
	})
}

func (h *Handler) handleOrderCreation(c *gin.Context) {
	order := orderFromForm(c)
	err := order.ValidateData()
	if err != nil {
		log.Println(err)
		c.Redirect(302, "/order/create")
		return
	}
	err = h.DB.CompleteOrder(&order)
	if err != nil {
		log.Println(err)
		return
	}
	c.HTML(http.StatusOK, "confirm-order", gin.H{
		"user":  getSessionUser(c),
		"order": order,
	})
}

// func (h *Handler) confirmOrder(c *gin.Context) {
// 	session := sessions.Default(c)

// 	c.HTML(http.StatusOK, "confirm-order", gin.H{
// 		"name": session.Get("name"),
// 	})
// }

func (h *Handler) handleConfirmOrder(c *gin.Context) {
	order := orderFromForm(c)
	user := getSessionUser(c)
	err := order.ValidateData()
	if err != nil {
		log.Println(err)
		c.Redirect(302, "/order/create")
		return
	}
	err = h.DB.CompleteOrder(&order)
	if err != nil {
		log.Println(err)
		return
	}
	if user.ID != 0 {
		err = h.DB.SaveCustomerOrder(&order, user.ID)
		if err != nil {
			log.Println(err)
			return
		}
	} else {
		err = h.DB.SaveOrder(&order)
		if err != nil {
			log.Println(err)
			return
		}
	}
	c.HTML(http.StatusOK, "order-created", gin.H{
		"order": order,
	})
}

func (h *Handler) serveOrderReceipt(c *gin.Context) {
	c.Header("Content-type", "application/pdf")
	pdf := gofpdf.New("P", "mm", "A5", "")
	pdf.AddPage()
	pdf.SetFont("Arial", "", 12)
	pdf.Write(10, "FICHE INFORMATIVE SUR LA COMMANDE \n")

	err := pdf.Output(c.Writer)
	if err != nil {
		log.Println("error while outputing pdf", err)
	}
}

func (h *Handler) cancelOrder(c *gin.Context) {
	orderID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.AbortWithStatusJSON(
			http.StatusInternalServerError,
			gin.H{
				"message": err.Error(),
			})
		return
	}
	user := getSessionUser(c)

	canceledID, err := h.DB.CancelOrder(orderID, user.ID)
	if err != nil {
		c.AbortWithStatusJSON(
			http.StatusInternalServerError,
			gin.H{
				"message": err.Error(),
			})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Commande %d annulé avec succès", canceledID),
	})
}
