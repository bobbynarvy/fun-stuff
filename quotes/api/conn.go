package api

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"os"
)

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}

	return fallback
}

func Connect() (*sql.DB, error) {
	dbHost := getEnv("MYSQL_HOST", "localhost")
	dbPort := getEnv("MYSQL_PORT", "3306")
	dbUser := getEnv("MYSQL_USER", "root")
	dbPass := getEnv("MYSQL_PASSWORD", "password")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/quotes", dbUser, dbPass, dbHost, dbPort)
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, err
	}

	return db, nil
}
