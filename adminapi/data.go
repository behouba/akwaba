package adminapi

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) systemData(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"areas":          h.sysData.Areas(),
		"categories":     h.sysData.ShipmentCategories(),
		"paymentOptions": h.sysData.PaymentOptions(),
	})
}
