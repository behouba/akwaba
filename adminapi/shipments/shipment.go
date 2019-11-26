package shipments

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba/mail"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func contextEmployee(c *gin.Context) (emp *akwaba.Employee) {
	e, ok := c.Get("employee")
	if !ok {
		panic(errors.New("No employee data"))
	}
	emp = e.(*akwaba.Employee)
	return
}

func (h *handler) PickUps(c *gin.Context) {
	emp := contextEmployee(c)
	shipments, err := h.shipmentStore.Pickups(c, &emp.Office)
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

func (h *handler) PickedUp(c *gin.Context) {
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
	err = h.shipmentStore.PickedUp(c, &emp.Office, shipmentID, weight)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(
		c, shipmentID,
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

func (h *handler) Stock(c *gin.Context) {
	emp := contextEmployee(c)
	shipments, err := h.shipmentStore.Stock(c, &emp.Office)
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

func (h *handler) CheckIn(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)
	err = h.shipmentStore.CheckIn(c, &emp.Office, shipmentID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(c, shipmentID, akwaba.ShipmentArrivedAtOfficeID, emp.Office.Area.ID)
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

func (h *handler) CheckOut(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)
	err = h.shipmentStore.CheckOut(c, &emp.Office, shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(c, shipmentID, akwaba.ShipmentLeftOfficeID, emp.Office.Area.ID)
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

func (h *handler) Deliveries(c *gin.Context) {
	emp := contextEmployee(c)
	shipments, err := h.shipmentStore.Deliveries(c, &emp.Office)
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

func (h *handler) Delivered(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)

	err = h.shipmentStore.Delivered(c, &emp.Office, shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(c, shipmentID, akwaba.ShipmentDeliveredID, emp.Office.Area.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	go func() {
		mail.SendDeliveryEmail(shipmentID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": "Livraison enregistrée",
	})
}

func (h *handler) FailedDelivery(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	emp := contextEmployee(c)
	err = h.shipmentStore.DeliveryFailed(c, &emp.Office, shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	err = h.shipmentStore.UpdateState(c, shipmentID, akwaba.ShipmentDeliveryFailedID, emp.Office.Area.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	go func() {
		mail.SendDeliveryFailureEmail(shipmentID)
	}()
	c.JSON(http.StatusOK, gin.H{
		"message": "Échec de livraison enregistré",
	})
	return
}
