package sms

import "fmt"

// SendAuthCode send validation digit code to user
// for authentication
func SendAuthCode(phone string) (err error) {
	fmt.Printf("sms send to %s \n", phone)
	return
}
