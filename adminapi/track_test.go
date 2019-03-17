package adminapi

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestUpdateOrderTracking(t *testing.T) {
	url := version + parcelBaseURL + "/update"

	req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte(`{"orderId": 34, "officeId": 1, "eventId": 1}`)))
	if err != nil {
		t.Fatal(err)
	}
	r := gin.Default()

	r.POST(url, testHandler.recordTrack)

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
	if status := w.Code; status != http.StatusOK {
		t.Fatalf("Test failed expected status %v, got %v", http.StatusOK, status)
	}
	t.Logf("Test succed with body %v", w.Body.String())
}
