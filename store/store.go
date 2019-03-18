package store

// DBConfig hold database connection info
type DBConfig struct {
	Port                             int
	DBName, Password, UserName, Host string
}
