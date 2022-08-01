package main

import (
	"context"
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"log"
	"os"
	"quotes/data"
)

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}

	return fallback
}

func connect() (*sql.DB, error) {
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

func main() {
	ctx := context.Background()
	db, err := connect()
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	queries := data.New(db)

	authors, err := queries.ListAuthors(ctx)
	if err != nil {
		log.Fatal(err)
	}

	for _, author := range authors {
		log.Println(author)
	}
}
