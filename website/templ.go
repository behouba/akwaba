package website

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (h *Handler) login(c *gin.Context) {
	_, isRedirect := c.GetQuery("redirect")

	log.Println(isRedirect)
	c.HTML(http.StatusOK, "login", gin.H{
		"isRedirect": isRedirect,
	})
}
func (h *Handler) home(c *gin.Context) {

	c.HTML(http.StatusOK, "home", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) about(c *gin.Context) {
	c.HTML(http.StatusOK, "about", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) services(c *gin.Context) {
	c.HTML(http.StatusOK, "services", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) tracking(c *gin.Context) {

	c.HTML(http.StatusOK, "tracking", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) conditions(c *gin.Context) {
	c.HTML(http.StatusOK, "conditions", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) privacyPolicy(c *gin.Context) {
	c.HTML(http.StatusOK, "privacy", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) businessContact(c *gin.Context) {
	c.HTML(http.StatusOK, "business", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) emergencyContact(c *gin.Context) {
	c.HTML(http.StatusOK, "emergency", gin.H{
		"user": sessionUser(c),
		// "cities": h.DB.Cities,
	})
}

func (h *Handler) handleEmergency(c *gin.Context) {
	name := c.PostForm("name")
	phone := c.PostForm("phone")
	cityID, _ := strconv.Atoi(c.PostForm("cityId"))
	address := c.PostForm("address")
	message := c.PostForm("message")

	log.Println(name, phone, cityID, address, message)
}

func (h *Handler) orderPricing(c *gin.Context) {
	c.HTML(http.StatusOK, "order-pricing", gin.H{
		"user":               sessionUser(c),
		"shipmentCategories": h.shipmentCategories,
	})
}

func (h *Handler) noRoute(c *gin.Context) {
	log.Println("404 page route triggered")
	c.HTML(http.StatusNotFound, "404", nil)
}

func (h *Handler) settings(c *gin.Context) {
	log.Println(sessionUser(c))
	c.HTML(http.StatusOK, "settings", gin.H{
		"user": sessionUser(c),
	})
}

func (h *Handler) customerOrders(c *gin.Context) {
	user := sessionUser(c)
	c.HTML(http.StatusOK, "user-orders", gin.H{
		"user": user,
	})
}
