package adminapi

import (
	"database/sql"
	"net/http"
	"strconv"

	"github.com/behouba/dsapi"
	"github.com/behouba/dsapi/adminapi/internal/jwt"
	"github.com/behouba/dsapi/adminapi/internal/notifier"
	"github.com/behouba/dsapi/adminapi/internal/postgres"
	"github.com/gin-gonic/gin"
)

// ParcelHandler implement methods set that handle request for parcel tracking actions
type ParcelHandler struct {
	Store dsapi.AdminParcelManager
	Auth  *jwt.Authenticator
	Sms   *notifier.SMS
}

// NewParcelHandler return new ParcelHandler
func NewParcelHandler(db *sql.DB, secret string) *ParcelHandler {
	return &ParcelHandler{
		Store: &postgres.ParcelStore{DB: db},
		Auth:  jwt.NewAdminAuth(secret),
	}
}

func (h *ParcelHandler) recordPickUp(c *gin.Context) {

}

func (h *ParcelHandler) recoredCheckIn(c *gin.Context) {

}

func (h *ParcelHandler) recordCheckOut(c *gin.Context) {

}

func (h *ParcelHandler) recordDelivery(c *gin.Context) {

}

func (h *ParcelHandler) trackParcel(c *gin.Context) {

}

func (h *ParcelHandler) recordTrack(c *gin.Context) {
	// var track dsapi.Track
	// if err := c.ShouldBindJSON(&track); err != nil {
	// 	c.JSON(http.StatusBadRequest, gin.H{
	// 		"error": err.Error(),
	// 	})
	// 	return
	// }
	// if err := h.Db.AddNewTrackingStep(&track); err != nil {
	// 	c.JSON(http.StatusBadRequest, gin.H{
	// 		"error": err.Error(),
	// 	})
	// 	return
	// }

	// c.JSON(http.StatusOK, gin.H{
	// 	"track": track,
	// })
}

func (h *ParcelHandler) nextEvent(c *gin.Context) {

	// should get office id from jwt
	officeID := 1
	orderID, err := strconv.Atoi(c.Param("orderId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	events, err := h.Store.Track(orderID, officeID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"events": events,
	})
}
