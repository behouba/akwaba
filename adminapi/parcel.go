package adminapi

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) officeParcels(c *gin.Context) {
	emp := getEmployee(c, h.auth)
	parcels, err := h.db.OfficeParcels(&emp)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, nil)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"parcels": parcels,
	})
}

func (h *Handler) parcelOut(c *gin.Context) {
	emp := getEmployee(c, h.auth)
	parcelID, err := strconv.Atoi(c.Query("parcel_id"))
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, nil)
		return
	}
	err = h.db.ParcelOut(parcelID, &emp)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Le colis a quitté l'agence",
	})
}

func (h *Handler) parcelIn(c *gin.Context) {
	emp := getEmployee(c, h.auth)
	trackID := c.Query("track_id")

	parcelID, err := akwaba.DecodeTrackID(trackID)
	if err != nil || parcelID == 0 {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Code de suivi incorrecte.",
		})
		return
	}
	err = h.db.ParcelIn(parcelID, &emp)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Colis à été ajouté au stock"),
	})
}

func (h *Handler) parcelsToDeliver(c *gin.Context) {
	emp := getEmployee(c, h.auth)

	parcels, err := h.db.ParcelsToDeliver(&emp)
	if err != nil {
		log.Println(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, nil)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"parcels": parcels,
	})
}

func (h *Handler) parcelDelivered(c *gin.Context) {
	emp := getEmployee(c, h.auth)

	parcelID, err := strconv.Atoi(c.Query("parcel_id"))

	if err != nil {
		log.Println(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	err = h.db.SetDeliveredParcel(parcelID, &emp)
	if err != nil {
		log.Println(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "La livraison du colis à été enregistrée",
	})

}
