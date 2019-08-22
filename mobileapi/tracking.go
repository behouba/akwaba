package mobileapi

import (
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) trackShipment(c *gin.Context) {
	id, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Numero du colis invalide",
		})
		return
	}
	var tracking akwaba.Tracking

	tracking, err = h.tracker.TrackByShipmentID(id)
	if err != nil {
		tracking, err = h.tracker.TrackByOrderID(id)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"message": err.Error(),
			})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"tracking": tracking,
	})

}
