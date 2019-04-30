package userapi

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestCreateOrder(t *testing.T) {
	url := version + orderBaseURL + "/create"
	cc := map[string]int{
		`{"paymentTypeId": 1,
			"customerId": 23,
			"productCategoryId": 4,
			"weight": 1000,
			"packingId": 3,
			"address": {
				"townId": 32,
				"ReceiverName": "Abla pokou",
				"Phone": "45001204",
				"map":{
					"longitude": 34.34,
					"latitude": 15.32
				},
				"description": "vers la pharmacie du bonheur"
			}
			}`: http.StatusOK,
		`{"paymentTypeId": 1,
			"customerId" 23,
			"productCategoryId": 4,
			"weight": 1000,
			"packingId": 3,
			"address": {
				"townId": 32,
				"ReceiverName": "Abla pokou",
				"Phone": "45001204",
				"map":{
					"longitude": 34.34,
					"latitude": 15.32
				},
				"description": "vers la pharmacie du bonheur"
			}
			}`: http.StatusBadRequest,
	}

	for s, c := range cc {
		req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte(s)))
		if err != nil {
			t.Fatal(err)
		}
		req.Header.Set("X-Custom-Header", "myvalue")
		req.Header.Set("Content-Type", "application/json")

		r := gin.Default()
		r.POST(url, u.createOrder)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("handler returned wrong status code: got %v want %v for %v",
				status, c, w.Body.String())
		}
		t.Log("success with response: ", w.Body.String())
	}
}

func TestCancelOrder(t *testing.T) {
	url := version + orderBaseURL + "/cancel"
	cc := map[string]int{
		"123":    http.StatusOK,
		"232":    http.StatusOK,
		"gkjhkh": http.StatusBadRequest,
	}
	for s, c := range cc {
		req, err := http.NewRequest("PUT", url+"/"+s, nil)
		if err != nil {
			t.Fatal(err)
		}

		r := gin.Default()
		r.PUT(url+"/:id", u.cancelOrder)

		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		if status := w.Code; status != c {
			t.Fatalf("handler returned wrong status code: got %v want %v for %v",
				status, c, w.Body.String())
		}
		t.Log("success with response: ", w.Body.String())
	}
}
