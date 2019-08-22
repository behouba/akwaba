package mobileapi

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

// should be removed when the api is ready
func (h *Handler) computePrice(c *gin.Context) {

	origin, destination := c.Query("origin"), c.Query("destination")

	pricing, err := h.pricing.Pricing(origin, destination)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, pricing)
}

func (h *Handler) getAreas(c *gin.Context) {
	c.JSON(http.StatusOK, h.sysData.Areas())
}
