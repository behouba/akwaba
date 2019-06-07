package adminapi

// Should implement a way to restrict access to this api (ip address, mac address etc...)

import (
	"log"
	"time"

	"github.com/behouba/akwaba/adminapi/internal/jwt"
	"github.com/behouba/akwaba/adminapi/internal/notifier"
	"github.com/behouba/akwaba/adminapi/internal/postgres"
	"github.com/gin-contrib/cors"
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
	AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
	AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type", "Authorization"},
	AllowCredentials: true,
	MaxAge:           12 * time.Hour,
})

// Handler represents the API handler methods set
type Handler struct {
	db     *postgres.AdminDB
	mailer *notifier.Mailer
	auth   *jwt.Authenticator
}

// SetupRouter create routes and return *gin.Engine
func SetupRouter(h *Handler) *gin.Engine {
	r := gin.Default()

	r.Use(corsConfig)
	v := r.Group(version)
	{
		v.GET("/system_data", h.systemData)
		a := v.Group(authBaseURL)
		{
			a.GET("/check", h.authMiddleware())
			a.POST("/login", h.login)
		}
		o := v.Group(orderBaseURL)
		o.Use(h.authMiddleware())
		{
			o.GET("/pending", h.pendingOrders)
			o.GET("/to_pick_up", h.ordersToPickUp)
			o.PATCH("/cancel/:id", h.cancelOrder)
			o.PATCH("/confirm/:id", h.confirmOrder)
			o.POST("/create", h.createOrder)
			o.PATCH("/set_collected", h.setCollectedOrders)
		}

		p := v.Group(parcelBaseURL)
		p.Use(h.authMiddleware())
		{
			p.GET("/parcels_in_stock/:officeID", h.officeParcels)
			p.PATCH("/parcels_out", h.parcelsOut)
			p.PATCH("/parcel_in/:trackID", h.parcelIn)
			p.GET("/to_deliver", h.parcelsToDeliver)
			p.PATCH("/parcels_delivered", h.parcelsDelivered)
			p.GET("/track", h.trackOrder)
		}
	}
	return r
}

func (h *Handler) setUpHandler(
	db *postgres.AdminDB, mailer *notifier.Mailer,
	authenticator *jwt.Authenticator,
) {
	h.db = db
	h.mailer = mailer
	h.auth = authenticator
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
	handler.setUpHandler(&db, notifier.NewMailer(), jwt.NewAdminAuth("administrateur_secret"))
	return &handler, err
}
