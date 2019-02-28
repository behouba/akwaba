package sms

import (
	"fmt"
	"math/rand"
	"strconv"
	"time"
)

// SendAuthCode send validation digit code to user
// for authentication and save given code with user id in redis with expiration time
func SendAuthCode(userID int, phone string) (code string, err error) {
	code = generateRandomCode()
	fmt.Printf("code %s sms send to %s \n", code, phone)
	return
}

func generateRandomCode() string {
	rand.Seed(time.Now().UnixNano())
	return strconv.Itoa(rand.Intn(9999-1000) + 1000)
}
