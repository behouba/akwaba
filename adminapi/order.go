package adminapi

// func getEmployee(c *gin.Context, auth *jwt.Authenticator) (emp akwaba.Employee) {
// 	token := strings.Split(c.GetHeader("Authorization"), " ")[1]
// 	emp, _ = auth.AuthenticateToken(token)
// 	return
// }

// func (h *Handler) ordersToPickUp(c *gin.Context) {
// 	emp := getEmployee(c, h.auth)

// 	orders, err := h.db.PendingOrders(emp.Office.ID)
// 	if err != nil {
// 		log.Println(err)
// 		c.JSON(http.StatusBadRequest, gin.H{
// 			"error": err.Error(),
// 		})
// 		return
// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"orders": orders,
// 	})
// }
