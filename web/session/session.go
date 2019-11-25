package session

import (
	"encoding/gob"
	"log"
	"strings"

	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

// Register User struct in order to be able to cast interface{} from session to User struct
func init() {
	gob.Register(akwaba.User{})
}

const (
	key = "user"
)

func GetContextUser(c *gin.Context, ts akwaba.TokenService) (user akwaba.User) {
	user = getApiUser(c, ts)
	if user.ID == 0 {
		user = GetWebsiteUser(c)
	}
	return
}

func GetWebsiteUser(c *gin.Context) (user akwaba.User) {
	s := sessions.Default(c)
	user, _ = s.Get(key).(akwaba.User)
	return
}

func getApiUser(c *gin.Context, ts akwaba.TokenService) (user akwaba.User) {
	auth := strings.Split(c.GetHeader("Authorization"), " ")
	if len(auth) < 2 {
		log.Println("no authorization header")
		return
	}

	user, err := ts.Authenticate(auth[1])
	if err != nil {
		log.Println(err)
		return
	}
	return user
}

func Save(user *akwaba.User, c *gin.Context) {
	// make password empty before saving user data into session
	user.Password = ""
	s := sessions.Default(c)
	s.Set(key, *user)
	s.Save()
}

func Destroy(c *gin.Context) {
	s := sessions.Default(c)
	s.Delete(key)
	s.Save()
}
