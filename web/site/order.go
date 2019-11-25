package site

import (
	"log"
	"net/http"
	"strconv"

	"github.com/behouba/akwaba/web/session"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *handler) orderPricingHTML(c *gin.Context) {
	c.HTML(http.StatusOK, "order-pricing", gin.H{
		"user":               session.GetWebsiteUser(c),
		"shipmentCategories": h.categoriesMap,
	})
}

func (h *handler) orderForm(c *gin.Context) {
	categoryID, _ := strconv.Atoi(c.Query("categoryId"))

	c.HTML(http.StatusOK, "order-form", gin.H{
		"user":           session.GetWebsiteUser(c),
		"origin":         c.Query("origin"),
		"destination":    c.Query("destination"),
		"categoryName":   h.categoriesMap[uint8(categoryID)],
		"categoryID":     categoryID,
		"paymentOptions": h.paymentOptionsMap,
	})
}

func (h *handler) orderSuccess(c *gin.Context) {
	orderID, err := strconv.ParseUint(c.Query("orderId"), 10, 64)
	if err != nil {
		log.Println(err)
		// c.Redirect(http.StatusSeeOther, "/")
		return
	}
	user := session.GetWebsiteUser(c)
	order, err := h.orderStore.Order(c, orderID, user.ID)
	if err != nil {
		log.Println(err)
		c.Redirect(http.StatusTemporaryRedirect, "/")
	}
	if order.State.ID != akwaba.OrderStatePendingID {
		c.Redirect(http.StatusTemporaryRedirect, "/")
	}
	c.HTML(http.StatusOK, "order-created", gin.H{
		"orderId": orderID,
	})
}
