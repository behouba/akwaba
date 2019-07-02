package userapi

import (
	"fmt"
	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"strconv"
)

const (
	cookieMaxAge = 31557600
)

// CheckPhone handler phone number verification to see if user is registered or not
func (h *Handler) checkPhone(c *gin.Context) {
	phone := c.Param("phone")

	// phone number format validation
	_, err := strconv.Atoi(phone)
	if (len(phone) != 8) || (err != nil) {
		authResponse(c, "Invalid phone number", http.StatusBadRequest)
		return
	}

	user, err := h.Db.CheckPhone(phone)
	if err != nil {
		authResponse(c, phone+" is not yet registered, pleasse register it.",
			http.StatusNotFound,
		)
		return
	}

	code, err := h.Sms.SendAuthCode(user.ID, phone)
	if err != nil {

		authResponse(c,
			"Sorry we failed to send you authentication sms to :"+phone,
			http.StatusInternalServerError,
		)
		return
	}

	err = h.Db.SaveAuthCode(phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	authResponse(c, "Authentication sms sent to: "+phone, http.StatusOK)
}

// Registration handler new customer registration
func (h *Handler) registration(c *gin.Context) {
	// donnee json a traiter contenant les info sur l'utilisateur
	var user dsapi.User
	if err := c.ShouldBindJSON(&user); err != nil {
		log.Println(err)
		c.Status(http.StatusBadRequest)
		return
	}
	newUser, statusCode, err := h.Db.SaveNewCustomer(&user)
	if err != nil {
		log.Println(err)
		authResponse(c, err.Error(), statusCode)
		return
	}
	code, err := h.Mailer.SendAuthCode(newUser)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	err = h.Db.SaveAuthCode(user.Phone, code)
	if err != nil {
		c.Status(http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "Authentication sms sent to: " + user.Phone,
	})
}

// ConfirmPhone handler make validation of customer phone number
func (h *Handler) confirmPhone(c *gin.Context) {
	code := c.Query("code")
	phone := c.Param("phone")

	_, err := strconv.Atoi(phone)
	log.Println(code, phone)
	if len(code) != 4 || len(phone) != 8 || err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Invalid request format",
		})
		if err != nil {
			log.Println(err)
		}
		return
	}

	if !h.Db.ConfirmSMSCode(phone, code) {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Provided code is not correct.",
		})
		return
	}

	user, err := h.Db.UserByPhone(phone)
	if err != nil {
		// should check error for internal server errors also
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Something went wrong with this request.",
		})
		return
	}

	isMobile := c.Request.Header.Get("Mobile-application")

	user.AccessToken, err = h.Auth.MakeCustomerJWT(user.ID, isMobile)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Something went wrong with this request.",
		})
		return
	}
	// Then send access token to customer and store it to postgresql database

	c.SetCookie("token", user.AccessToken, cookieMaxAge, "/", "", false, false)
	c.JSON(http.StatusOK, gin.H{
		"message": "Verification successed",
		"user":    user,
	})

}

func (h *Handler) authRequired(c *gin.Context) {
	token := c.Request.Header.Get("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Sorry you are not authenticated.",
		})
		c.Abort()
		return
	}
	userID, err := h.Auth.ValidateJWT(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": err.Error(),
			"token":   token,
		})
		c.Abort()
		return
	}
	c.Set("userID", userID)
}

func (h *Handler) login(c *gin.Context) {
	var user dsapi.User
	if err := c.ShouldBindJSON(&user); err != nil {
		log.Println(err)
		c.Status(http.StatusBadRequest)
		return
	}
	u, err := h.Db.Authenticate(user.Email, user.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "Information de connexion non valide",
		})
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "authentication succeded.",
		"user":    u,
	})
}

func (h *Handler) logout(c *gin.Context) {

}

// func (h *Handler) lookForValidToken(c *gin.Context) {
// 	token := c.Request.Header.Get("Authorization")
// 	userID, err := h.Auth.ValidateJWT(token)
// 	if err == nil {
// 		c.JSON(http.StatusUnauthorized, gin.H{
// 			"message": "You already have a valid access token",
// 		})
// 		c.Abort()
// 		return
// 	}
// 	log.Println("user id: ", userID, err.Error())
// }

func (h *Handler) setAuthState(c *gin.Context) {
	token, err := c.Cookie("token")
	if token == "" || err != nil {
		return
	}
	userID, err := h.Auth.ValidateJWT(token)
	if err != nil {
		return
	}
	c.Set("userID", userID)
}

func (h *Handler) checkAuthState(c *gin.Context) {
	token, err := c.Cookie("token")
	log.Println("token value from cookie: ", token)
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "You are not authenticated",
		})
		return
	}
	userID, err := h.Auth.ValidateJWT(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "You are not authenticated",
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("user %d you have a valid access token", userID),
	})
}

func authResponse(c *gin.Context, message string, statusCode int) {
	c.JSON(statusCode, gin.H{
		"message": message,
	})
}
