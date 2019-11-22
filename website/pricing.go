package website

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (h *Handler) computePrice(c *gin.Context) {

	origin, destination := c.Query("origin"), c.Query("destination")
	categoryID, _ := strconv.Atoi(c.Query("categoryId"))

	// compute pricing for all categories when categoryId query params is missing
	if categoryID == 0 {
		origin, destination := c.Query("origin"), c.Query("destination")
		pricing, err := h.pricing.Pricing(origin, destination)
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

	cost, dist, err := h.pricing.Cost(origin, destination, uint8(categoryID))
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

func (h *Handler) areas(c *gin.Context) {
	query := c.Query("q")
	if query == "" {
		c.JSON(http.StatusOK, h.sysData.Areas())
		return
	}
	areas := h.pricing.FindArea(query)
	c.JSON(http.StatusOK, gin.H{
		"areas": areas,
	})
}
