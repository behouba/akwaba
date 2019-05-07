package adminapi

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/behouba/akwaba"
	"github.com/behouba/akwaba/adminapi/internal/jwt"
	"github.com/gin-gonic/gin"
)

// ===================================
// AdminUserManager interface implementation
type userMockStore struct{}

func (u *userMockStore) GetUserByPhone(phone string) (user []akwaba.User, err error) {
	return
}

func (u *userMockStore) GetUserByName(name string) (user []akwaba.User, err error) {
	return
}

func (u *userMockStore) GetDeliveryAddress(userID int) (add []akwaba.Address, err error) {
	return
}

func (u *userMockStore) GetPickUpAddress(userID int) (add []akwaba.Address, err error) {
	return
}
func (u *userMockStore) SaveUser(user *akwaba.User) (id int, err error) {
	return
}
func (u *userMockStore) SaveDeliveryAddress(userID int, address *akwaba.Address) (err error) {
	return
}
func (u *userMockStore) SavePickUpAddress(userID int, address *akwaba.Address) (err error) {
	return
}
func (u *userMockStore) FreezeUser(userID int) (err error) {
	return
}
func (u *userMockStore) UnFreezeUser(userID int) (err error) {
	return
}

// =====================================

var uTestHandler = &UserHandler{Store: &userMockStore{}, Auth: jwt.NewAdminAuth("test-auth")}

func TestCreateUser(t *testing.T) {
	url := version + userBaseURL + "/profile"

	cc := map[string]int{
		`{"fullName": "Kouame behouba manasse", "phone": "45001685", "email": "behouba@gmail.com"}`: http.StatusOK,
		`{"fullName": "behouba@gmail.com", "phone": "58753408", ""}`:                                http.StatusBadRequest,
		`{"hello": "world", "kouame": "behouba"}`:                                                   http.StatusBadRequest,
	}

	for s, c := range cc {
		req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte(s)))
		if err != nil {
			t.Fatal(err)
		}
		req.Header.Set("Content-Type", "application/json")

		r := gin.Default()
		r.POST(url, uTestHandler.createCustomer)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("handler returned wrong status code: got %v want %v for %v",
				status, c, w.Body.String())
		}
		t.Log("success with response: ", w.Body.String())
	}
}
