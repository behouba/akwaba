package mail

import (
	"fmt"
	"math/rand"
	"strconv"
	"time"
)

// SMS hold methods set to manage sms action
type SMS struct {
}

// NewSMS return new sms objet
func NewSMS() *SMS {
	return &SMS{}
}

// SendAuthCode send validation digit code to user
// for authentication and save given code with user id in redis with expiration time
func (s *SMS) SendAuthCode(userID int, phone string) (code string, err error) {
	code = generateRandomCode()
	fmt.Printf("code %s sms send to %s \n", code, phone)
	return
}

func generateRandomCode() string {
	rand.Seed(time.Now().UnixNano())
	return strconv.Itoa(rand.Intn(9999-1000) + 1000)
}
