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

func strToi32(str string) int32 {
	str64, _ := strconv.ParseInt(str, 10, 64)
	return int32(str64)
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
		id := strToi32(vars["id"])

		author, err := env.Queries.GetAuthor(ctx, id)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Printf("GET /authors/%s\n", vars["id"])
		json.NewEncoder(w).Encode(author)
	}
}

func quotesHandler(env *Env) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		ctx := context.Background()

		if authorId := req.URL.Query().Get("author-id"); authorId != "" {
			id := strToi32(authorId)
			quotes, err := env.Queries.GetQuotesByAuthor(ctx, id)

			if err != nil {
				log.Fatal(err)
			}

			fmt.Printf("GET /quotes?author-id=%s\n", authorId)
			json.NewEncoder(w).Encode(quotes)
			return
		}

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
