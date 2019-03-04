package userapi

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/behouba/dsapi/platform/jwt"
	"github.com/behouba/dsapi/platform/notifier"
	"github.com/behouba/dsapi/platform/postgres"
	"github.com/behouba/dsapi/platform/redis"

	"github.com/gin-gonic/gin"
)

func Userhandler() *Handler {
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

	return &Handler{
		Db:    db,
		Cache: cache,
		Auth:  auth,
		Sms:   sms,
	}
}

var u = Userhandler()

func TestRegisterGuest(t *testing.T) {
	url := version + authBaseURL + "/registration"
	cc := map[string]int{
		`{"firstName": "Harry", "lastName": "Potter", "phone": "45001685"}`:                   http.StatusOK,
		`{"firstName": "", "lastName": "Uzumaki", "phone": "58753408"}`:                       http.StatusBadRequest,
		`{"firstName": "Sasuke", "lastName": "Uchiwa", "phone": "43324324242"}`:               http.StatusBadRequest,
		`{"firstName": "Sasuke", "lastName": "Uchiwa", "phone": "unfauxjs"}`:                  http.StatusBadRequest,
		`{"firstName": "Hitashi", "lastName": "Uchiwa", "phone": "34343434", "townId": "34"}`: http.StatusBadRequest,
	}

	for s, c := range cc {
		req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte(s)))
		if err != nil {
			t.Fatal(err)
		}
		req.Header.Set("X-Custom-Header", "myvalue")
		req.Header.Set("Content-Type", "application/json")

		r := gin.Default()
		r.POST(url, u.registration)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("handler returned wrong status code: got %v want %v",
				status, c)
		}
		t.Log("success with response: ", w.Body.String())
	}

}

func TestCheckGuestPhone(t *testing.T) {

	pp := map[string]int{
		"45001685":            http.StatusOK,
		"3433":                http.StatusBadRequest,
		"saitama":             http.StatusBadRequest,
		"4893489348934893493": http.StatusBadRequest,
		"58753408":            http.StatusOK,
	}
	for p, c := range pp {
		url := version + authBaseURL + "/phone/check/"

		req, err := http.NewRequest("GET", url+p, nil)
		if err != nil {
			t.Fatal(err)
		}
		r := gin.Default()
		r.GET(url+":phone", u.checkPhone)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("phone check failed: handler returned wrong status code: got %v want %v for %s with body = %v",
				status, c, p, w.Body.String())
		}
		t.Log("phone check success", w.Body.String())
	}

}

func TestPhoneValidation(t *testing.T) {
	// create code for testing validation handler
	values := []struct {
		Phone     string
		Code      string
		GuestCode string
		Status    int
	}{{
		"45001685",
		"4545",
		"4545",
		http.StatusOK,
	},
		{
			"48239342",
			"3434",
			"343454",
			http.StatusBadRequest,
		},
		{
			"58753408",
			"4344",
			"4348",
			http.StatusUnauthorized,
		},
	}

	for _, v := range values {

		err := u.Cache.SaveAuthCode(v.Phone, v.Code)
		if err != nil {
			t.Fatalf("Test failed while trying to save code to redis: %v", err)
		}

		url := version + authBaseURL + "/phone/confirm/" + v.Phone + "?code=" + v.GuestCode

		req, err := http.NewRequest("GET", url, nil)
		if err != nil {
			t.Fatal(err)
		}
		r := gin.Default()
		r.GET(version+authBaseURL+"/phone/confirm/:phone", u.confirmPhone)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != v.Status {
			t.Fatalf("phone check failed: handler returned wrong status code: got %v want %v. err : %v",
				status, v.Status, w.Body.String())
		}
		t.Log("phone confirmation succed", w.Body.String())

	}

}
