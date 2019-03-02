package redis

import (
	"fmt"
	"time"

	"github.com/go-redis/redis"
)

var redisClient *redis.Client

func init() {
	redisClient = redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})
	pong, err := redisClient.Ping().Result()
	if err != nil {
		panic(err)
	}
	fmt.Println("redis server here", pong)
}

// SaveAuthCode store code send to user by sms to redis
func SaveAuthCode(phone, code string) (err error) {
	return redisClient.Set(phone, code, 15*time.Minute).Err()
}

// ConfirmSMSCode take guest user phone number with verification code
// and check in redis is this phone number correspond to this code
func ConfirmSMSCode(phone string, code string) (valid bool) {
	c, err := redisClient.Get(phone).Result()
	if err != nil {
		return false
	}
	if c == code {
		redisClient.Del(phone)
		return true
	}
	return false
}
