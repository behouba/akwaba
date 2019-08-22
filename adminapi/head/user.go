package head

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) Users(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"users": h.userStore.Users(),
	})
}
