package mobileapi

import (
	"strings"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) contextUser(c *gin.Context) (user akwaba.User) {
	auth := strings.Split(c.GetHeader("Authorization"), " ")
	if len(auth) < 2 {
		return
	}

	user, err := h.jwt.Authenticate(auth[1])
	if err != nil {
		return
	}
	return user
}
