package api

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"quotes/data"
	"strconv"
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

func authorHandler(env *Env) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		ctx := context.Background()
		vars := mux.Vars(req)
		id64, _ := strconv.ParseInt(vars["id"], 10, 64)
		id := int32(id64)

		author, err := env.Queries.GetAuthor(ctx, id)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Printf("GET /authors/%s", vars["id"])
		json.NewEncoder(w).Encode(author)
	}
}

func quotesHandler(env *Env) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		ctx := context.Background()
		quotes, err := env.Queries.ListQuotes(ctx)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Println("GET /quotes")
		json.NewEncoder(w).Encode(quotes)
	}
}

func Serve(env *Env) {
	r := mux.NewRouter()
	r.HandleFunc("/authors", authorsHandler(env)).Methods("GET")
	r.HandleFunc("/authors/{id:[0-9]+}", authorHandler(env)).Methods("GET")
	r.HandleFunc("/quotes", quotesHandler(env)).Methods("GET")
	http.Handle("/", r)
	http.ListenAndServe(":8080", nil)
}
