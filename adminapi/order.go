package adminapi

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) pendingOrders(c *gin.Context) {
	orders, err := h.Db.PendingOrders(5)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"orders": orders,
	})
}
func (h *Handler) orderInfo(c *gin.Context) {

}
func (h *Handler) confirmOrder(c *gin.Context) {

}

func (h *Handler) cancelOrder(c *gin.Context) {

}

func (h *Handler) orderReceipt(c *gin.Context) {

}
