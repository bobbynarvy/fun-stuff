package main

import (
	"errors"
	"fmt"
	"strings"
)

type KVStore map[string]string

type Request struct {
	method string
	value  []string
}

func parsePayload(payload string) (*Request, error) {
	parsed := strings.Split(payload, " ")

	if len(parsed) == 0 {
		return nil, errors.New("No key set.")
	}

	switch parsed[0] {
	case "GET":
		if len(parsed) < 2 {
			return nil, errors.New("Missing GET argument.")
		}
		return &Request{"GET", parsed[1:2]}, nil
	case "POST":
		if len(parsed) < 3 {
			return nil, errors.New("Missing POST arguments.")
		}
		return &Request{"POST", parsed[1:3]}, nil
	default:
		return nil, errors.New("Invalid method.")
	}
}

func processRequest(request *Request, kv KVStore) (string, error) {
	key := request.value[0]

	switch request.method {
	case "GET":
		if val, ok := kv[key]; ok {
			return val, nil
		}

		return "", errors.New("Value not found.")
	case "POST":
		value := request.value[1]
		kv[key] = value

		return fmt.Sprintf("Updated value of %s with %s", key, value), nil
	default:
		return "", errors.New("Invalid method.")
	}
}

func main() {
	m := make(KVStore)
	payload := "POST hello world"
	parsed, _ := parsePayload(payload)
	processRequest(parsed, m)
	payload = "GET hello"
	parsed, _ = parsePayload(payload)
	result, _ := processRequest(parsed, m)
	fmt.Println(result)
}
