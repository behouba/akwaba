package site

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) orders(c *gin.Context) {
	user := getSessionUser(c)
	page, _ := strconv.Atoi(c.Query("page"))

	if page == 2 {
		c.HTML(http.StatusOK, "archive-orders", gin.H{
			"user": user,
		})
		return
	}

	c.HTML(http.StatusOK, "active-orders", gin.H{
		"user": user,
	})

}

func (h *Handler) ordersJSON(c *gin.Context) {
	user := getSessionUser(c)
	t := c.Param("type")

	if t == "active" {
		orders, err := h.DB.ActiveOrders(user.ID)
		if err != nil {
			log.Println(err)
		}
		c.JSON(http.StatusOK, gin.H{
			"orders": orders,
		})
	} else if t == "archive" {
		orders, err := h.DB.ArchivedOrders(user.ID)
		if err != nil {
			log.Println(err)
		}
		c.JSON(http.StatusOK, gin.H{
			"orders": orders,
		})
	}
}

func (h *Handler) settings(c *gin.Context) {
	c.HTML(http.StatusOK, "settings", gin.H{
		"user":   getSessionUser(c),
		"cities": h.DB.Cities,
	})
}

func (h *Handler) updateProfile(c *gin.Context) {
	var data akwaba.User
	user := getSessionUser(c)
	data.FullName = c.PostForm("name")
	data.Phone = c.PostForm("phone")
	data.Email = c.PostForm("email")
	data.City.ID, _ = strconv.Atoi(c.PostForm("cityId"))
	data.Address = c.PostForm("address")
	data.Password = c.PostForm("password")
	log.Println(data)
	newUser, err := h.DB.UpdateUser(&data, user.ID)
	if err != nil {
		log.Println(err)
		c.HTML(http.StatusExpectationFailed, "settings", gin.H{
			"user":   getSessionUser(c),
			"error":  err.Error(),
			"cities": h.DB.Cities,
		})
		return
	}
	saveSessionUser(&newUser, c)

	c.HTML(http.StatusOK, "settings", gin.H{
		"user":    getSessionUser(c),
		"success": "Votre profil a été mis à jour avec succès",
		"cities":  h.DB.Cities,
	})
}
