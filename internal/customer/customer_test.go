package customer

import (
	"testing"
)

func TestParseCustomerInfo(t *testing.T) {
	cc := map[string]error{
		`{"firstName": "Harry", "lastName": "Potter", "phone": "45001685"}`:       nil,
		`{"firstName": "", "lastName": "Uzumaki", "phone": "58753408"}`:           errFullNameIsRequired,
		`{"firstName": "Sasuke", "lastName": "Uchiwa", "phone": "5875334324234"}`: errInvalidPhone,
		`{"firstName": "Sasuke", "lastName": "Uchiwa", "phone": "unfauxjs"}`:      errInvalidPhone,
	}
	for s, e := range cc {
		_, err := ParseCustomerInfo([]byte(s))
		if e != err {
			t.Fatal(err)
		}
		t.Logf("Test with %s json passed", s)
	}
}
