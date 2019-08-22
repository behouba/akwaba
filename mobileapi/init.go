package mobileapi


import (
	"encoding/gob"

	"github.com/behouba/akwaba"
)

// Register User struct in order to be able to cast interface{} from session to User struct
func init() {
	gob.Register(akwaba.User{})
}
