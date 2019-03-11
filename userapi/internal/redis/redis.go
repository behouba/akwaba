package redis

import (
	"fmt"
	"time"

	"github.com/go-redis/redis"
)

// Cache client struct
type Cache struct {
	client *redis.Client
}

// New function init redis connection
func New() (cache *Cache, err error) {
	client := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})
	pong, err := client.Ping().Result()
	if err != nil {
		return
	}
	cache = &Cache{client}
	fmt.Println("redis server here", pong)
	return
}

// SaveAuthCode store code send to user by sms to redis
func (r *Cache) SaveAuthCode(phone, code string) (err error) {
	return r.client.Set(phone, code, 15*time.Minute).Err()
}

// ConfirmSMSCode take guest user phone number with verification code
// and check in redis is this phone number correspond to this code
func (r *Cache) ConfirmSMSCode(phone string, code string) (valid bool) {
	c, err := r.client.Get(phone).Result()
	if err != nil {
		return false
	}
	if c == code {
		r.client.Del(phone)
		return true
	}
	return false
}
