package api

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"quotes/data"
	"strconv"
)

type Env struct {
	Queries *data.Queries
}

var AuthorNotFound = "Author not found"
var UnexpectedError = "Unexpected error"

func strToi32(str string) int32 {
	str64, _ := strconv.ParseInt(str, 10, 64)
	return int32(str64)
}

func errResp(w *http.ResponseWriter, err error, msg string, status int) {
	http.Error(*w, msg, status)
	log.Println(err.Error())
}

func authorsHandler(env *Env) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		log.Println("GET /authors")

		ctx := context.Background()
		authors, err := env.Queries.ListAuthors(ctx)
		if err != nil {
			errResp(&w, err, UnexpectedError, 500)
			return
		}

		json.NewEncoder(w).Encode(authors)
	}
}

func authorHandler(env *Env) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		ctx := context.Background()
		vars := mux.Vars(req)
		id := strToi32(vars["id"])
		log.Printf("GET /authors/%s\n", vars["id"])

		author, err := env.Queries.GetAuthor(ctx, id)
		if err != nil {
			switch err {
			case sql.ErrNoRows:
				errResp(&w, err, AuthorNotFound, 404)
			default:
				errResp(&w, err, UnexpectedError, 500)
			}
			return
		}

		json.NewEncoder(w).Encode(author)
	}
}

func quotesHandler(env *Env) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		ctx := context.Background()

		if authorId := req.URL.Query().Get("author-id"); authorId != "" {
			id := strToi32(authorId)
			log.Printf("GET /quotes?author-id=%s\n", authorId)

			quotes, err := env.Queries.GetQuotesByAuthor(ctx, id)
			if quotes == nil {
				errResp(&w, errors.New(AuthorNotFound), AuthorNotFound, 404)
				return
			}
			if err != nil {
				errResp(&w, err, UnexpectedError, 500)
				return
			}

			json.NewEncoder(w).Encode(quotes)
			return
		}

		log.Println("GET /quotes")
		quotes, err := env.Queries.ListQuotes(ctx)
		if err != nil {
			errResp(&w, err, UnexpectedError, 500)
			return
		}

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
