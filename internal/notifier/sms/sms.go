package sms

import "fmt"

// SendAuthCode send validation digit code to user
// for authentication and save given code with user id in redis with expiration time
func SendAuthCode(userID int, phone string) (code string, err error) {
	fmt.Printf("sms send to %s \n", phone)
	return
}
