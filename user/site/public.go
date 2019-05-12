package site

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (h *Handler) home(c *gin.Context) {

	c.HTML(http.StatusOK, "home", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) about(c *gin.Context) {
	c.HTML(http.StatusOK, "about", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) services(c *gin.Context) {
	c.HTML(http.StatusOK, "services", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) tracking(c *gin.Context) {

	c.HTML(http.StatusOK, "tracking", gin.H{
		"user": getSessionUser(c),
	})
}
func (h *Handler) pricing(c *gin.Context) {
	c.HTML(http.StatusOK, "pricing", gin.H{
		"user":            getSessionUser(c),
		"cities":          h.DB.Cities,
		"weightIntervals": h.DB.WeightIntervals,
	})
}

func (h *Handler) conditions(c *gin.Context) {
	c.HTML(http.StatusOK, "conditions", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) privacyPolicy(c *gin.Context) {
	c.HTML(http.StatusOK, "privacy", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) businessContact(c *gin.Context) {
	c.HTML(http.StatusOK, "business", gin.H{
		"user": getSessionUser(c),
	})
}

func (h *Handler) emergencyContact(c *gin.Context) {
	c.HTML(http.StatusOK, "emergency", gin.H{
		"user":   getSessionUser(c),
		"cities": h.DB.Cities,
	})
}

func (h *Handler) handleContact(c *gin.Context) {
	name := c.PostForm("name")
	phone := c.PostForm("phone")
	email := c.PostForm("email")
	message := c.PostForm("message")

	log.Println(name, phone, email, message)
}

func (h *Handler) handleEmergency(c *gin.Context) {
	name := c.PostForm("name")
	phone := c.PostForm("phone")
	cityID, _ := strconv.Atoi(c.PostForm("cityId"))
	address := c.PostForm("address")
	message := c.PostForm("message")

	log.Println(name, phone, cityID, address, message)
}
