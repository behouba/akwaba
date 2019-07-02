package website

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

// import (
// 	"log"
// 	"net/http"

// 	"github.com/behouba/akwaba"
// 	"github.com/gin-gonic/gin"
// )

// func (h *Handler) orders(c *gin.Context) {
// 	user := sessionUser(c)
// 	c.HTML(http.StatusOK, "user-orders", gin.H{
// 		"user": user,
// 	})

// }

func (h *Handler) handleContact(c *gin.Context) {
	name := c.PostForm("name")
	phone := c.PostForm("phone")
	email := c.PostForm("email")
	message := c.PostForm("message")

	log.Println(name, phone, email, message)
}

// func (h *Handler) ordersJSON(c *gin.Context) {
// 	user := sessionUser(c)
// 	t := c.Param("type")

// 	if t == "active" {
// 		orders, err := h.DB.ActiveOrders(user.ID)
// 		if err != nil {
// 			log.Println(err)
// 		}
// 		c.JSON(http.StatusOK, gin.H{
// 			"orders": orders,
// 		})
// 	} else if t == "archive" {
// 		orders, err := h.DB.ArchivedOrders(user.ID)
// 		if err != nil {
// 			log.Println(err)
// 		}
// 		c.JSON(http.StatusOK, gin.H{
// 			"orders": orders,
// 		})
// 	}
// }

func (h *Handler) settings(c *gin.Context) {
	log.Println(sessionUser(c))
	c.HTML(http.StatusOK, "settings", gin.H{
		"user": sessionUser(c),
		// "cities": h.DB.Cities,
	})
}

// func (h *Handler) updateProfile(c *gin.Context) {
// 	user := sessionUser(c)
// 	var data akwaba.Customer
// 	if err := c.ShouldBindJSON(&data); err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusBadRequest, gin.H{
// 			"user":    sessionUser(c),
// 			"message": err.Error(),
// 		})
// 		return
// 	}
// 	log.Println(data)
// 	newUser, err := h.DB.UpdateUser(&data, user.ID)
// 	if err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusInternalServerError, gin.H{
// 			"user":    sessionUser(c),
// 			"message": err.Error(),
// 		})
// 		return
// 	}
// 	saveSessionUser(&newUser, c)

// 	c.JSON(http.StatusOK, gin.H{
// 		"user":    sessionUser(c),
// 		"message": "Votre profil a été mis à jour avec succès",
// 	})
// }

// func (h *Handler) profileData(c *gin.Context) {
// 	user := sessionUser(c)
// 	c.JSON(http.StatusOK, gin.H{
// 		"user": user,
// 	})
// }
