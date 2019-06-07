package adminapi

import (
	"fmt"
	"log"
	"net/http"

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

func (h *Handler) parcelsOut(c *gin.Context) {
	emp := getEmployee(c, h.auth)
	var ids []int64
	var message string

	if err := c.ShouldBind(&ids); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, nil)
		return
	}
	h.db.ParcelsOut(ids, emp.Office.ID)

	if len(ids) > 1 {
		message = fmt.Sprintf("%d colis ont quittés le bureau", len(ids))
	} else {
		message = "le colis a quitté le bureau"
	}
	c.JSON(http.StatusOK, gin.H{
		"message": message,
	})
}

func (h *Handler) parcelIn(c *gin.Context) {
	emp := getEmployee(c, h.auth)
	trackID := c.Param("trackID")

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
	}

	c.JSON(http.StatusOK, gin.H{
		"parcels": parcels,
	})
}

func (h *Handler) parcelsDelivered(c *gin.Context) {
	emp := getEmployee(c, h.auth)

	var message string
	var ids []int

	if err := c.ShouldBind(&ids); err != nil {
		log.Println(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, nil)
		return
	}

	h.db.SetDeliveredParcels(ids, &emp)

	if len(ids) > 1 {
		message = fmt.Sprintf("%d colis ont étés livrés", len(ids))
	} else {
		message = "le colis a été livré"
	}
	c.JSON(http.StatusOK, gin.H{
		"message": message,
	})

}
