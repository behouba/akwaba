package mail

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/behouba/akwaba"
)

// SendOrderCreationEmail send transaction email to user after order creation
func SendOrderCreationEmail(orderID uint64) (err error) {
	url := fmt.Sprintf("%s/order/creation?id=%d", akwaba.MailerBaseURL, orderID)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func SendWelcomeEmail(ctx context.Context, firstName, email string) (err error) {
	url := fmt.Sprintf("%s/welcome?first_name=%s&email=%s", akwaba.MailerBaseURL, firstName, email)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}

func SendRecoveryEmail(ctx context.Context, email, token string) (err error) {
	url := fmt.Sprintf("%s/recovery?email=%s&token=%s", akwaba.MailerBaseURL, email, token)
	_, err = http.Get(url)
	if err != nil {
		log.Println(err)
	}
	return
}
