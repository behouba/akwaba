package main

import (
	"github.com/behouba/dsapi/platform/jwt"
	"github.com/behouba/dsapi/platform/notifier"
	"github.com/behouba/dsapi/platform/postgres"
	"github.com/behouba/dsapi/platform/redis"
	"github.com/behouba/dsapi/userapi"
)

func main() {

	// ==================================================
	// Database connection
	// ==================================================

	db, err := postgres.Open()
	if err != nil {
		panic(err)
	}

	// =================================================
	// Redis cache connection // should after pass config
	// =================================================

	cache, err := redis.New()
	if err != nil {
		panic(err)
	}

	// =================================================
	// JSON web token authenticator // should after pass config
	// =================================================
	auth := jwt.NewAuthenticator([]byte("my_secret_customer_key_should_be_in_config_file"))

	// =================================================
	// SMS notifier service // should after pass config
	// =================================================
	sms := notifier.NewSMS()

	handler := &userapi.Handler{
		Db:    db,
		Cache: cache,
		Auth:  auth,
		Sms:   sms,
	}
	r := userapi.SetupRouter(handler)
	r.Run()
}
