package adminapi

// this should be deleted asap. Should rely on the ver
// func (h *Handler) trackOrder(c *gin.Context) {
// trackID := c.Query("track_id")

// parcelID, err := akwaba.DecodeTrackID(trackID)
// if err != nil || parcelID == 0 {
// 	log.Println(err)
// 	c.JSON(http.StatusBadRequest, gin.H{
// 		"message": "Code de suivi incorrecte.",
// 	})
// 	return
// }

// tracking, err := h.db.TrackParcel(parcelID)
// if err != nil {
// 	log.Println(err)
// 	c.JSON(http.StatusInternalServerError, gin.H{
// 		"message": err.Error(),
// 	})
// 	return
// }
// c.JSON(http.StatusOK, gin.H{
// 	"tracking": tracking,
// })

// }
