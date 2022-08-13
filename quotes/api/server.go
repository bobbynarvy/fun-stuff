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

type Env struct {
	Queries *data.Queries
}

func authorsHandler(env *Env) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		ctx := context.Background()
		authors, err := env.Queries.ListAuthors(ctx)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Println("GET /authors")
		json.NewEncoder(w).Encode(authors)
	}
}

func Serve(env *Env) {
	r := mux.NewRouter()
	r.HandleFunc("/authors", authorsHandler(env)).Methods("GET")
	http.Handle("/", r)
	http.ListenAndServe(":8080", nil)
}
