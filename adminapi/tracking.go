package adminapi

import (
	"net/http"

	"github.com/behouba/dsapi"
	"github.com/gin-gonic/gin"
)

func (h *Handler) updateOrderLocation(c *gin.Context) {

}

func (h *Handler) recordTrack(c *gin.Context) {
	var track dsapi.Track
	if err := c.ShouldBindJSON(&track); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	if err := h.Db.AddNewTrackingStep(&track); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"track": track,
	})

}

func (h *Handler) trackingSteps(c *gin.Context) {

}
