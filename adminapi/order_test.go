package adminapi

// import (
// 	"net/http"
// 	"net/http/httptest"
// 	"testing"

// 	"github.com/gin-gonic/gin"
// )

// func TestPendingOrders(t *testing.T) {
// 	url := version + orderBaseURL + "/news"

// 	req, err := http.NewRequest("GET", url, nil)
// 	if err != nil {
// 		t.Fatal(err)
// 	}
// 	r := gin.Default()

// 	r.GET(url, testHandler.pendingOrders)

// 	w := httptest.NewRecorder()
// 	r.ServeHTTP(w, req)
// 	if status := w.Code; status != http.StatusOK {
// 		t.Fatalf("Test failed expected status %v, got %v", http.StatusOK, status)
// 	}
// 	t.Logf("Test succed with body %v", w.Body.String())
// }

// func TestOrderInfo(t *testing.T) {
// 	url := version + orderBaseURL + "/info/"
// 	cc := map[string]int{
// 		"343": http.StatusOK,
// 		"yes": http.StatusBadRequest,
// 	}

// 	for s, c := range cc {
// 		req, err := http.NewRequest("GET", url+s, nil)
// 		if err != nil {
// 			t.Fatal(err)
// 		}
// 		r := gin.Default()

// 		r.GET(url+":orderId", testHandler.orderInfo)

// 		w := httptest.NewRecorder()
// 		r.ServeHTTP(w, req)
// 		if status := w.Code; status != c {
// 			t.Fatalf("Test failed expected status %v, got %v", c, status)
// 		}
// 		t.Logf("Test succed with body %v", w.Body.String())
// 	}
// }

// func TestConfirmOrder(t *testing.T) {
// 	url := version + orderBaseURL + "/confirm/"
// 	cc := map[string]int{
// 		"343": http.StatusOK,
// 		"yes": http.StatusBadRequest,
// 	}

// 	for s, c := range cc {
// 		req, err := http.NewRequest("PATCH", url+s, nil)
// 		if err != nil {
// 			t.Fatal(err)
// 		}
// 		r := gin.Default()

// 		r.PATCH(url+":orderId", testHandler.orderInfo)

// 		w := httptest.NewRecorder()
// 		r.ServeHTTP(w, req)
// 		if status := w.Code; status != c {
// 			t.Fatalf("Test failed expected status %v, got %v", c, status)
// 		}
// 		t.Logf("Test succed with body %v", w.Body.String())
// 	}
// }
