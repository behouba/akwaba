package office

import "testing"

func TestLogin(t *testing.T) {
	return
}

func Fact(n int) int {
	if n > 1 {
		return Fact(n - 1)
	}
	if n == 1 {
		return 0
	}
	return n
}
