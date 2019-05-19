package site

import (
	"net/http"
	"strconv"
	"time"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

func (h *Handler) trackOrder(c *gin.Context) {
	time.Sleep(time.Second * 3)

	orderID, _ := strconv.Atoi(c.Query("id"))

	var tracking akwaba.Tracking

	p := akwaba.Parcel{
		Weight:           0.5,
		Nature:           "Téléphone portable",
		SenderFullName:   "Jhon Doe",
		ReceiverFullName: "Bob marley",
		Origin:           "Adjamé",
		Destination:      "Cocody",
	}

	var events []akwaba.TrackingEvent

	for i := 0; i < 6; i++ {
		t := akwaba.EventTime{RealTime: time.Now()}
		t.FormatTimeFR()
		events = append(
			events,
			akwaba.TrackingEvent{
				Time:   t,
				Status: "Arrivé à l'agence",
				Place:  "Abobo gare"},
		)
	}

	tracking.OrderID = orderID
	tracking.Events = events
	tracking.Parcel = p

	c.JSON(http.StatusOK, gin.H{
		"tracking": tracking,
	})

}
