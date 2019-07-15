package adminapi

import (
	"net/http"

	"github.com/behouba/akwaba/postgres"
	"github.com/gin-gonic/gin"
)

func systemData(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"areas":          postgres.Areas(),
		"categories":     postgres.ShipmentCategories(),
		"paymentOptions": postgres.PaymentOptions(),
	})
}
