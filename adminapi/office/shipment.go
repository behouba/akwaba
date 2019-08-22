package office

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func sendDeliveryEmail(shipmentID uint64) (err error) {
	url := fmt.Sprintf("%s/shipment/delivery?id=%d", akwaba.MailerBaseURL, shipmentID)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func sendDeliveryFailureEmail(shipmentID uint64) (err error) {
	url := fmt.Sprintf("%s/shipment/delivery_failure?id=%d", akwaba.MailerBaseURL, shipmentID)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func contextEmployee(c *gin.Context) (emp *akwaba.Employee) {
	e, ok := c.Get("employee")
	if !ok {
		panic(errors.New("No employee data"))
	}
	emp = e.(*akwaba.Employee)
	return
}

func (h *Handler) PickUps(c *gin.Context) {
	emp := contextEmployee(c)
	shipments, err := h.shipmentStore.Pickups(&emp.Office)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"shipments": shipments,
	})
}

func (h *Handler) PickedUp(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	weight, err := strconv.ParseFloat(c.Query("weight"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)
	err = h.shipmentStore.PickedUp(&emp.Office, shipmentID, weight)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(
		shipmentID,
		akwaba.ShipmentPickedUpID,
		emp.Office.Area.ID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Ramassage du colis %d sauvegardé", shipmentID),
	})
}

func (h *Handler) Stock(c *gin.Context) {
	emp := contextEmployee(c)
	shipments, err := h.shipmentStore.Stock(&emp.Office)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"stock": shipments,
	})
}

func (h *Handler) CheckIn(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)
	err = h.shipmentStore.CheckIn(&emp.Office, shipmentID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(shipmentID, akwaba.ShipmentArrivedAtOfficeID, emp.Office.Area.ID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Colis ajouté au stock",
	})
}

func (h *Handler) CheckOut(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)
	err = h.shipmentStore.CheckOut(&emp.Office, shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(shipmentID, akwaba.ShipmentLeftOfficeID, emp.Office.Area.ID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Colis sorti de l'agence",
	})
}

func (h *Handler) Deliveries(c *gin.Context) {
	emp := contextEmployee(c)
	shipments, err := h.shipmentStore.Deliveries(&emp.Office)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"shipments": shipments,
	})
}

func (h *Handler) Delivered(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)

	err = h.shipmentStore.Delivered(&emp.Office, shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(shipmentID, akwaba.ShipmentDeliveredID, emp.Office.Area.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	go func() {
		sendDeliveryEmail(shipmentID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": "Livraison enregistrée",
	})
}

func (h *Handler) FailedDelivery(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)
	err = h.shipmentStore.DeliveryFailed(&emp.Office, shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(shipmentID, akwaba.ShipmentDeliveryFailedID, emp.Office.Area.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	go func() {
		sendDeliveryFailureEmail(shipmentID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": "Échec de livraison enregistré",
	})
	return
}
