package main

import (
	"log"
	"quotes/api"
	"quotes/data"
)

func main() {
	db, err := api.Connect()
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	env := &api.Env{Queries: data.New(db)}

	api.Serve(env)
}
