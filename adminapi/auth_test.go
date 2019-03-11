package adminapi

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

var testHandler = AdminHandler("", "", "test_jwt")

func TestLogin(t *testing.T) {
	url := version + authBaseURL + "/login"

	cc := map[string]int{
		`{"email": "behouba@gmail.com", "password": "12345"}`: http.StatusOK,
		`{"email": "inconnu@gmail.com", "password": "54321"}`: http.StatusUnauthorized,
		`{"hello": "world", "kouame": "behouba"}`:             http.StatusBadRequest,
	}

	for s, c := range cc {
		req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte(s)))
		if err != nil {
			t.Fatal(err)
		}
		req.Header.Set("Content-Type", "application/json")

		r := gin.Default()
		r.POST(url, testHandler.login)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("handler returned wrong status code: got %v want %v for %v",
				status, c, w.Body.String())
		}
		t.Log("success with response: ", w.Body.String())
	}
}
