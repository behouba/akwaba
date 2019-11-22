package website

import (
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) trackingHTML(c *gin.Context) {

	c.HTML(http.StatusOK, "tracking", gin.H{
		"user": sessionUser(c),
	})
}

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
				"error": err.Error(),
			})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"tracking": tracking,
	})

}

func (h *Handler) offices(c *gin.Context) {
	c.JSON(http.StatusOK, h.sysData.Offices())
}
