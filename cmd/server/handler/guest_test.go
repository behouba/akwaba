package handler

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestRegisterGuest(t *testing.T) {
	url := customerBaseURL + "/registration"
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
		r.POST(url, registerGuest)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("handler returned wrong status code: got %v want %v",
				status, c)
		}
		t.Log("success")
	}

}

func TestCheckGuestPhone(t *testing.T) {

	pp := map[string]int{
		"45001685":            http.StatusOK,
		"343":                 http.StatusBadRequest,
		"saitama":             http.StatusBadRequest,
		"4893489348934893493": http.StatusBadRequest,
		"58753408":            http.StatusOK,
	}
	for p, c := range pp {
		url := guestBaseURL + "/phone/check"

		req, err := http.NewRequest("GET", url+"?p="+p, nil)
		if err != nil {
			t.Fatal(err)
		}
		r := gin.Default()
		r.GET(url, checkGuestPhone)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("phone check failed: handler returned wrong status code: got %v want %v for %s",
				status, c, p)
		}
		t.Log("phone check success", w.Body.String())
	}

}
