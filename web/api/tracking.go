package api

import (
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *handler) trackShipment(c *gin.Context) {
	id, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Numero du colis invalide",
		})
		return
	}
	var tracking akwaba.Tracking

	tracking, err = h.tracker.TrackShipment(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"tracking": tracking,
	})

}

func (h *handler) offices(c *gin.Context) {
	c.JSON(http.StatusOK, h.locationService.Offices(c))
}
