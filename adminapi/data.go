package adminapi

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) systemData(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"cities":          h.db.Cities,
		"weightIntervals": h.db.WeightIntervals,
		"paymentTypes":    h.db.PaymentTypes,
	})
}
