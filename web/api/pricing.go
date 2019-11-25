package api

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (h *handler) computePrice(c *gin.Context) {

	origin, destination := c.Query("origin"), c.Query("destination")
	categoryID, _ := strconv.Atoi(c.Query("categoryId"))

	// compute pricing for all categories when categoryId query params is missing
	if categoryID == 0 {
		origin, destination := c.Query("origin"), c.Query("destination")
		pricing, err := h.pricingService.Pricing(c, origin, destination)
		if err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, gin.H{
				"error": err.Error(),
			})
			return
		}
		c.JSON(http.StatusOK, pricing)
		return
	}

	cost, dist, err := h.pricingService.Cost(c, uint8(categoryID), origin, destination)
	if err != nil {
		log.Println(err)
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

func (h *handler) areas(c *gin.Context) {
	query := c.Query("q")
	if query == "" {
		c.JSON(http.StatusOK, h.locationService.Areas(c))
		return
	}
	areas := h.pricingService.FindAreas(c, query)
	c.JSON(http.StatusOK, gin.H{
		"areas": areas,
	})
}
