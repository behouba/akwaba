package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"log"
	"time"

	"github.com/behouba/akwaba/adminapi/internal/notifier"
	"github.com/behouba/akwaba/adminapi/internal/postgres"
	"github.com/gin-contrib/cors"
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

var corsConfig = cors.New(cors.Config{
	AllowOrigins:     []string{"http://localhost:8080"},
	AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD"},
	AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type"},
	AllowCredentials: false,
	MaxAge:           12 * time.Hour,
})

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

	r.Use(corsConfig)

	v := r.Group(version)
	{
		o := v.Group(orderBaseURL)
		{
			o.GET("/to_confirm", h.ordersToConfirm)
			o.GET("/to_pick_up", h.ordersToPickUp)
			o.POST("/cancel/:id", h.cancelOrder)
			o.POST("/confirm/:id", h.confirmOrder)
			o.POST("/create", h.createOrder)
		}
	}
	return r
}

func (h *Handler) setUpHandler(db *postgres.AdminDB, mailer *notifier.Mailer) {
	h.db = db
	h.mailer = mailer
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
