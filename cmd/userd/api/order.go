package api

import (
	"time"

	"github.com/gin-gonic/gin"
)

type order struct {
	ID                int
	PaymentTypeID     int
	CustomerID        int
	ProductCategoryID int
	Weight            float64
	Cost              int
	CreatedAt         time.Time
	Description       string
	PackingID         int
	Address           address
}

type mapPoint struct {
	Longitude float64
	Latitude  float64
}
type address struct {
	ID           int
	TownID       int
	ReceiverName string
	Phone        string
	Map          mapPoint
	Description  string
}

func (h *Handler) createOrder(c *gin.Context) {

}

func (h *Handler) computeOrderCost(c *gin.Context) {

}

func (h *Handler) cancelOrder(c *gin.Context) {

}

func (h *Handler) trackOrder(c *gin.Context) {

}

func (h *Handler) allOrders(c *gin.Context) {

}
