package adminapi

import (
	"bytes"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/behouba/akwaba/adminapi/internal/jwt"

	"github.com/behouba/dsapi"
	"github.com/gin-gonic/gin"
)

type tAuthStore struct{}

func (t *tAuthStore) Check(a *dsapi.AdminCredential) (emp dsapi.Employee, err error) {
	if a.Name != "behouba" || a.Password != "12345" {
		err = errors.New("Invalid creadential for login")
		return
	}
	return
}

var tAHandler = AuthHandler{Store: &tAuthStore{}, Auth: jwt.NewAdminAuth("testJWT")}

func TestLogin(t *testing.T) {
	url := version + authBaseURL + "/login"

	cc := map[string]int{
		`{"name": "behouba", "password": "12345"}`:           http.StatusOK,
		`{"name": "inconnu@gmail.com", "password": "54321"}`: http.StatusUnauthorized,
		`{"hello": "world", "kouame": "behouba"}`:            http.StatusBadRequest,
	}

	for s, c := range cc {
		req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte(s)))
		if err != nil {
			t.Fatal(err)
		}
		req.Header.Set("Content-Type", "application/json")

		r := gin.Default()
		r.POST(url, tAHandler.login)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("handler returned wrong status code: got %v want %v for %v",
				status, c, w.Body.String())
		}
		t.Log("success with response: ", w.Body.String())
	}
}
