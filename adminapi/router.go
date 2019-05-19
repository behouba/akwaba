package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"log"

	"github.com/behouba/akwaba/adminapi/internal/notifier"
	"github.com/behouba/akwaba/adminapi/internal/postgres"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
)

const (
	version       = "/v0"
	authBaseURL   = "/auth"
	orderBaseURL  = "/order"
	parcelBaseURL = "/parcel"
	userBaseURL   = "/user"
)

// Handler represents the API handler methods set
type Handler struct {
	db     *postgres.AdminDB
	mailer *notifier.Mailer
}

// SetupRouter create routes and return *gin.Engine
func SetupRouter(h *Handler) *gin.Engine {
	r := gin.Default()
	store := cookie.NewStore([]byte("akwaba"))
	r.Use(sessions.Sessions("akwaba-admin", store))
	v := r.Group(version)
	v.Use(CORSMiddleware())
	{
		o := v.Group(orderBaseURL)
		{
			o.GET("/pending", h.pendingOrders)
			o.POST("/cancel/:id", h.cancelOrder)
			o.POST("/confirm/:id", h.confirmOrder)
		}
	}
	return r
}

func (h *Handler) setUpHandler(db *postgres.AdminDB, mailer *notifier.Mailer) {
	h.db = db
	h.mailer = mailer
}
func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, PATCH, GET, PUT")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

// NewHandler return new handler and and error if one
func NewHandler(dbURI string) (*Handler, error) {
	db := postgres.AdminDB{}
	err := db.Open(dbURI)
	if err != nil {
		log.Println(err)
		return nil, err
	}
	handler := Handler{}
	handler.setUpHandler(&db, notifier.NewMailer())
	return &handler, err
}
