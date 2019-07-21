package adminapi

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// this should be deleted asap. Should rely on the ver
func (h *Handler) trackOrder(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}

	tracking, err := h.tracker.Track(shipmentID)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"tracking": tracking,
	})

}
