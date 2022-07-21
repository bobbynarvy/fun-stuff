package main

import (
	"errors"
	"fmt"
	"log"
	"net"
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
	case "SET":
		if len(parsed) < 3 {
			return nil, errors.New("Missing SET arguments.")
		}
		return &Request{"SET", parsed[1:3]}, nil
	default:
		return nil, errors.New("Invalid method.")
	}
}

func processRequest(request *Request, kv KVStore) (string, error) {
	key := request.value[0]

	switch request.method {
	case "GET":
		if val, ok := kv[key]; ok {
			log.Printf("GET %s => %s", key, val)
			return val, nil
		}

		return "", errors.New("Value not found.")
	case "SET":
		val := request.value[1]
		kv[key] = val
		log.Printf("SET %s to %s", key, val)

		return fmt.Sprintf("Updated value of %s with %s", key, val), nil
	default:
		return "", errors.New("Invalid method.")
	}
}

func handleConn(conn net.Conn, kv KVStore) {
	buffer := make([]byte, 1024)
	_, err := conn.Read(buffer)
	if err != nil {
		log.Fatal(err)
		return
	}

	payload := string(buffer)
	log.Printf("Received payload: %s", payload)
	parsed, err := parsePayload(payload)
	if err != nil {
		log.Fatal(err)
		return
	}

	result, err := processRequest(parsed, kv)
	// if err != nil {
	// 	log.Fatal(err)
	// }

	conn.Write([]byte(result))
	conn.Close()
}

func main() {

	kv := make(KVStore)

	listener, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatal(err)
	}
	defer listener.Close()

	log.Println("Key-value server listening...")

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Fatal(err)
		}

		handleConn(conn, kv)
	}
}
