package api

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"quotes/data"
)

func authorsHandler(w http.ResponseWriter, req *http.Request) {
	db, err := connect()
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	queries := data.New(db)

	ctx := context.Background()
	authors, err := queries.ListAuthors(ctx)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("GET /authors")
	json.NewEncoder(w).Encode(authors)
}

func Serve() {
	r := mux.NewRouter()
	r.HandleFunc("/authors", authorsHandler).Methods("GET")
	http.Handle("/", r)
	http.ListenAndServe(":8080", nil)
}
