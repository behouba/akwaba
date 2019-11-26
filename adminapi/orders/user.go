package orders

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *handler) Users(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"users": h.userStore.Users(),
	})
}
