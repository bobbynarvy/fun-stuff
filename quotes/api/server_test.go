//go:build integration
// +build integration

package api

import (
	"context"
	"log"
	"net/http"
	"quotes/data"
	"testing"
)

var url = "http://localhost:8080"

func TestMain(m *testing.M) {
	db, err := Connect()
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	c, cancel := context.WithCancel(context.Background())
	env := &Env{Queries: data.New(db), Context: &c}

	go Serve(env)

	// run tests
	m.Run()

	// shutdown server once tests are done
	cancel()
}

func TestQuotes(t *testing.T) {
	res, err := http.Get(url + "/quotes")
	if err != nil {
		t.Errorf("GET /quotes failed: %v", err)
	}

	if res.StatusCode != 200 {
		t.Errorf("GET /quotes failed; Status: %d", res.StatusCode)
	}
}

func TestQuotesByAuthor(t *testing.T) {
	res, err := http.Get(url + "/quotes?author-id=1")
	if err != nil {
		t.Errorf("GET /quotes?author-id={id} failed: %v", err)
	}

	if res.StatusCode != 200 {
		t.Errorf("GET /quotes?author-id={id} failed; Status: %d", res.StatusCode)
	}
}

func TestAuthors(t *testing.T) {
	res, err := http.Get(url + "/authors")
	if err != nil {
		t.Errorf("GET /authors failed: %v", err)
	}

	if res.StatusCode != 200 {
		t.Errorf("GET /authors failed; Status: %d", res.StatusCode)
	}
}

func TestAuthor(t *testing.T) {
	res, err := http.Get(url + "/authors/1") // id 1 should exist in the DB
	if err != nil {
		t.Errorf("GET /authors/{id} failed: %v", err)
	}

	if res.StatusCode != 200 {
		t.Errorf("GET /authors/{id} failed; Status: %d", res.StatusCode)
	}
}

func TestNonExistentAuthor(t *testing.T) {
	res, err := http.Get(url + "/authors/100000")
	if err != nil {
		t.Errorf("GET /authors/{id} failed: %v", err)
	}

	if res.StatusCode != 404 {
		t.Errorf("GET /authors/{id} failed; Should be 404; Status: %d", res.StatusCode)
	}
}
