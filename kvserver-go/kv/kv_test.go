package kv

import (
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	go Serve()
	exitVal := m.Run()
	os.Exit(exitVal)
}

func TestSet(t *testing.T) {
	client := Client{"localhost:8080"}

	result, err := client.Set("hello", "world")
	if result != "world" || err != nil {
		t.Fatalf(`Set("hello") = %v`, err)
	}
}

func TestGet(t *testing.T) {
	client := Client{"localhost:8080"}

	result, err := client.Get("hello")
	if result != "world" || err != nil {
		t.Fatalf(`Get("hello") = %v`, err)
	}
}

func TestGetInvalidKey(t *testing.T) {
	client := Client{"localhost:8080"}

	_, err := client.Get("something")
	if err == nil {
		t.Fatalf(`Get("hello") should have an error`)
	}
}
