package handler

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestRegisterCustomer(t *testing.T) {
	url := "/v0/customer/registration"
	cc := map[string]int{
		`{"firstName": "Harry", "lastName": "Potter", "phone": "45001685"}`:     http.StatusOK,
		`{"firstName": "", "lastName": "Uzumaki", "phone": "58753408"}`:         http.StatusBadRequest,
		`{"firstName": "Sasuke", "lastName": "Uchiwa", "phone": "43324324242"}`: http.StatusBadRequest,
		`{"firstName": "Sasuke", "lastName": "Uchiwa", "phone": "unfauxjs"}`:    http.StatusBadRequest,
	}

	for s, c := range cc {
		req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte(s)))
		if err != nil {
			t.Fatal(err)
		}
		req.Header.Set("X-Custom-Header", "myvalue")
		req.Header.Set("Content-Type", "application/json")

		r := gin.Default()
		r.POST(url, registerCustomer)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Errorf("handler returned wrong status code: got %v want %v",
				status, c)
		}
		t.Log("success", w.Body.String())
	}

}
