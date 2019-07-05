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
	categoryID, _ := strconv.Atoi(c.Query("categoryId"))

	cost, dist, err := h.calculator.Cost(origin, destination, uint8(categoryID))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Echec de la requête.",
		})
		return
	}
	log.Println(origin, destination, categoryID)
	c.JSON(http.StatusOK, gin.H{
		"origin":      origin,
		"destination": destination,
		"distance":    dist,
		"cost":        cost,
	})
}
