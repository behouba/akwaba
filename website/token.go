package website

import (
	"log"
	"strings"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) apiUser(c *gin.Context) (user akwaba.User) {
	auth := strings.Split(c.GetHeader("Authorization"), " ")
	if len(auth) < 2 {
		log.Println("no authorization header")
		return
	}

	user, err := h.jwt.Authenticate(auth[1])
	if err != nil {
		log.Println(err)
		return
	}
	return user
}
