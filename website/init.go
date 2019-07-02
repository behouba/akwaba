package website

import (
	"encoding/gob"

	"github.com/behouba/akwaba"
)

// Register Customer struct in order to be able to cast interface{} from session to Customer struct
func init() {
	gob.Register(akwaba.Customer{})
}
