package website

import (
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

func (h *Handler) computePrice(c *gin.Context) {

	originID, _ := strconv.Atoi(c.Query("originId"))

	destinationID, _ := strconv.Atoi(c.Query("destinationId"))

	ShipmentCategoryID, _ := strconv.Atoi(c.Query("ShipmentCategoryId"))

	time.Sleep(time.Second * 3)
	log.Println(originID, destinationID, ShipmentCategoryID)

	c.JSON(http.StatusOK, gin.H{
		"price": 4500.0,
	})
}
