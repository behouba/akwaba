package store

const (
	host     = "localhost"
	port     = 5432
	user     = "optimus92"
	password = "labierequisait"
	dbname   = "akwabaTestDB"
	// JWTDevSecret jwt secret
	JWTDevSecret = "akatsukietlepoulet"
)

// DBConfig hold database connection info
type DBConfig struct {
	Port                     int
	DB, Password, User, Host string
}

// DevDBConfig defaut config for database connexion for dev server
var DevDBConfig = DBConfig{Port: port, Host: host, User: user, Password: password, DB: dbname}
