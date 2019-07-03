package website

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// should be removed when the api is ready
func (h *Handler) computePrice(c *gin.Context) {

	origin, destination := c.Query("origin"), c.Query("destination")
	shipmentCategoryID, _ := strconv.Atoi(c.Query("shipmentCategoryId"))

	dist, err := h.distanceAPI.CalculateDistance(origin, destination)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Echec de la requête.",
		})
	}
	price, err := h.calculator.Cost(dist, uint(shipmentCategoryID))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Echec de la requête.",
		})
	}
	log.Println(origin, destination, shipmentCategoryID)
	c.JSON(http.StatusOK, gin.H{
		"origin":      origin,
		"destination": destination,
		"distance":    dist,
		"price":       price,
	})
}
