package adminapi

// import (
// 	"fmt"
// 	"log"
// 	"net/http"
// 	"strconv"

// 	"github.com/gin-gonic/gin"
// )

// func (h *Handler) parcelsToPickUp(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)

// 	parcels, err := h.db.ParcelsToPickUp(emp.Office.ID)
// 	if err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusBadRequest, nil)
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"parcels": parcels,
// 	})
// }

// func (h *Handler) officeParcels(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)
// 	parcels, err := h.db.OfficeParcels(&emp)
// 	if err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusBadRequest, nil)
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"parcels": parcels,
// 	})
// }

// func (h *Handler) parcelOut(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)
// 	parcelID, err := strconv.ParseUint(c.Query("parcel_id"), 10, 64)
// 	if err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusBadRequest, nil)
// 		return
// 	}
// 	err = h.db.ParcelOut(parcelID, &emp)
// 	if err != nil {
// 		c.JSON(http.StatusInternalServerError, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}

// 	c.JSON(http.StatusOK, gin.H{
// 		"message": "Le colis a quitté l'agence",
// 	})
// }

// func (h *Handler) parcelIn(c *gin.Context) {
// 	// emp := getEmployee(c, h.auth)
// 	// trackID := c.Query("track_id")

// 	// err = h.db.ParcelIn(parcelID, &emp)
// 	// if err != nil {
// 	// 	log.Println(err)
// 	// 	c.JSON(http.StatusInternalServerError, gin.H{
// 	// 		"message": err.Error(),
// 	// 	})
// 	// 	return
// 	// }
// 	c.JSON(http.StatusOK, gin.H{
// 		"message": fmt.Sprintf("Colis à été ajouté au stock"),
// 	})
// }

// func (h *Handler) parcelsToDeliver(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)

// 	parcels, err := h.db.ParcelsToDeliver(&emp)
// 	if err != nil {
// 		log.Println(err)
// 		c.AbortWithStatusJSON(http.StatusInternalServerError, nil)
// 		return
// 	}

// 	c.JSON(http.StatusOK, gin.H{
// 		"parcels": parcels,
// 	})
// }

// func (h *Handler) parcelDelivered(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)

// 	parcelID, err := strconv.ParseUint(c.Query("parcel_id"), 10, 64)
// 	if err != nil {
// 		log.Println(err)
// 		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}

// 	err = h.db.SetDeliveredParcel(parcelID, &emp)
// 	if err != nil {
// 		log.Println(err)
// 		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"message": "La livraison du colis à été enregistrée",
// 	})

// }

// func (h *Handler) collected(c *gin.Context) {
// 	orderID, err := strconv.ParseUint(c.Query("order_id"), 10, 64)
// 	if err != nil {
// 		c.JSON(http.StatusBadRequest, gin.H{
// 			"message": "Numero de commande non valide.",
// 		})
// 		return
// 	}
// 	weight, err := strconv.ParseFloat(c.Query("weight"), 64)
// 	if err != nil || weight > 50 || weight <= 0 {
// 		c.JSON(http.StatusBadRequest, gin.H{
// 			"message": "Poids du colis invalide.",
// 		})
// 		return
// 	}
// 	emp := getEmployee(c, h.auth)

// 	err = h.db.SetCollected(orderID, weight, emp.Office.ID)
// 	if err != nil {
// 		c.JSON(http.StatusInternalServerError, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}

// 	c.JSON(http.StatusOK, gin.H{
// 		"message": "Ramassage enregistré avec succès.",
// 	})
// }

// func (h *Handler) failedDelivery(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)

// 	parcelID, err := strconv.ParseUint(c.Query("parcel_id"), 10, 64)
// 	if err != nil {
// 		log.Println(err)
// 		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}
// 	err = h.db.SetDeliveryFailed(parcelID, &emp)
// 	if err != nil {
// 		c.JSON(http.StatusInternalServerError, gin.H{
// 			"message": err.Error(),
// 		})
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"message": "Echec de livraison enregistré.",
// 	})
// }
