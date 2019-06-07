package adminapi

import (
	"net/http"
	"time"

	"github.com/behouba/akwaba"
	"github.com/gin-gonic/gin"
)

// this should be deleted asap. Should rely on the ver
func (h *Handler) trackOrder(c *gin.Context) {
	time.Sleep(time.Second * 3)

	trackID := c.Query("track_id")

	var tracking akwaba.Tracking

	var p akwaba.Parcel
	p.Nature = "Téléphone portable"
	p.Sender.FullName = "Jhon Doe"
	p.Receiver.FullName = "Bob marley"
	p.Sender.City.Name = "Adjamé"
	p.Receiver.City.Name = "Cocody"

	var events []akwaba.Event

	for i := 0; i < 6; i++ {
		t := akwaba.EventTime{RealTime: time.Now()}
		t.FormatTimeFR()
		events = append(
			events,
			akwaba.Event{
				Time:  t,
				Title: "Arrivé à l'agence",
				City:  akwaba.City{Name: "Abobo gare"}},
		)
	}

	tracking.TrackID = trackID
	tracking.Events = events
	tracking.Parcel = p

	c.JSON(http.StatusOK, gin.H{
		"tracking": tracking,
	})

}
