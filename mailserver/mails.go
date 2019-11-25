package mailserver

import (
	"bytes"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
	"gopkg.in/gomail.v2"
)

type userData struct {
	FirstName string
	Token     string
	Email     string
}

// newMessage set email headers and return pointer to gomail.Message
func newMessage(body, subjet, mailFrom, mailTo string) (msg *gomail.Message) {
	msg = gomail.NewMessage()
	msg.SetAddressHeader("From", mailFrom, "Akwaba Express")
	msg.SetHeader("To", mailTo)
	msg.SetHeader("X-Entity-Ref-ID")
	msg.SetHeader("Subject", subjet)
	msg.SetBody("text/html", body)
	return
}

func generateHTML(templ *template.Template, templateName string, data interface{}) (emailBody string, err error) {
	var tpl bytes.Buffer
	err = templ.ExecuteTemplate(&tpl, templateName, data)
	if err != nil {
		return
	}
	emailBody = tpl.String()
	return
}

// WelcomeEmail send welcome email to new registred user
func (h *Handler) welcomeEmail(c *gin.Context) {
	firstName, email := c.Query("first_name"), c.Query("email")
	if firstName == "" || email == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "user_name and user_email queries are required",
		})
		return
	}
	body, err := generateHTML(h.templ, "welcome", firstName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	msg := newMessage(body, welcomeSubjet, h.config.Email, email)
	err = h.dialer.DialAndSend(msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Welcome email sent to %s", email),
	})
}

func (h *Handler) recoveryEmail(c *gin.Context) {
	userEmail, token := c.Query("email"), c.Query("token")
	if userEmail == "" || token == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "token and user_email queries are required",
		})
		return
	}
	firstName, err := h.store.FromEmail(userEmail)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	data := &userData{FirstName: firstName, Token: token}

	body, err := generateHTML(h.templ, "recovery", data)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	msg := newMessage(body, resetPasswordSubjet, h.config.Email, userEmail)
	err = h.dialer.DialAndSend(msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Password recovery email sent to %s", userEmail),
	})
}

func (h *Handler) orderCreationEmail(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	var user akwaba.User
	user.FirstName, user.Email, err = h.store.FromOrderID(orderID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	body, err := generateHTML(h.templ, "order-creaction", &user)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	msg := newMessage(body, fmt.Sprintf("COMMANDE Nº %d", orderID), h.config.Email, user.Email)
	err = h.dialer.DialAndSend(msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Order creation email sent to %s", user.Email),
	})
}
func (h *Handler) orderConfirmationEmail(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	var user akwaba.User
	user.FirstName, user.Email, err = h.store.FromOrderID(orderID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	body, err := generateHTML(h.templ, "confirmation", orderID)
	if err != nil {
		return
	}
	msg := newMessage(body, fmt.Sprintf("CONFIRMATION DE COMMANDE Nº %d", orderID), h.config.Email, user.Email)
	err = h.dialer.DialAndSend(msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Order confirmation email sent to %s", user.Email),
	})
}

func (h *Handler) orderCancelationEmail(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	var user akwaba.User
	user.FirstName, user.Email, err = h.store.FromOrderID(orderID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	body, err := generateHTML(h.templ, "cancelation", orderID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	msg := newMessage(body, fmt.Sprintf("COMMANDE Nº %d ANNULÉE", orderID), h.config.Email, user.Email)
	err = h.dialer.DialAndSend(msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Order cancelation email sent to %s", user.Email),
	})
}

// func (h *Handler) trackingStateChangeEmail(c *gin.Context) {

// 	return
// }

func (h *Handler) deliveryEmail(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	var user akwaba.User
	user.FirstName, user.Email, err = h.store.FromShipmentID(shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	body, err := generateHTML(h.templ, "delivery", shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	msg := newMessage(body, fmt.Sprintf("COLIS Nº %d LIVRÉ", shipmentID), h.config.Email, user.Email)
	err = h.dialer.DialAndSend(msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Delivery email sent to %s", user.Email),
	})
}

func (h *Handler) deliveryFailureEmail(c *gin.Context) {
	shipmentID, err := strconv.ParseUint(c.Query("id"), 10, 64)
	var user akwaba.User
	user.FirstName, user.Email, err = h.store.FromShipmentID(shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}

	body, err := generateHTML(h.templ, "delivery-failure", shipmentID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	msg := newMessage(body, fmt.Sprintf("ÉCHEC DE LIVRAISON DU COLIS Nº %d", shipmentID), h.config.Email, user.Email)
	err = h.dialer.DialAndSend(msg)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Delivery failure email sent to %s", user.Email),
	})
}
