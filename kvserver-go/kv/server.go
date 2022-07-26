package kv

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
	trimmed := strings.Trim(payload, "\r\n")
	parsed := strings.Split(trimmed, " ")

	if len(parsed) == 0 {
		return nil, errors.New("No key set.")
	}

	switch parsed[0] {
	case "GET":
		if len(parsed) < 2 {
			return nil, errors.New("Missing GET argument.")
		}
		return &Request{"GET", parsed[1:]}, nil
	case "SET":
		if len(parsed) < 3 {
			return nil, errors.New("Missing SET arguments.")
		}
		return &Request{"SET", parsed[1:]}, nil
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

		return "", fmt.Errorf("Value not found for %s.", key)
	case "SET":
		val := request.value[1]
		kv[key] = val
		log.Printf("SET %s to %s", key, val)

		return val, nil
	default:
		return "", errors.New("Invalid method.")
	}
}

func writeResponse(conn net.Conn, successResp string, errorResp error) {
	if errorResp != nil {
		conn.Write([]byte(fmt.Sprintf("ERROR %s\n", errorResp.Error())))
		conn.Close()
		return
	}

	conn.Write([]byte(fmt.Sprintf("OK %s\n", successResp)))
	conn.Close()
}

func handleConn(conn net.Conn, kv KVStore) error {
	buffer := make([]byte, 1024)
	n, err := conn.Read(buffer)
	if err != nil {
		writeResponse(conn, "", errors.New(err.Error()))
	}

	payload := string(buffer[:n])
	log.Printf("Received payload: %s", payload)
	request, err := parsePayload(payload)
	if err != nil {
		writeResponse(conn, "", err)
	}

	response, err := processRequest(request, kv)
	if err != nil {
		writeResponse(conn, "", err)
	}

	writeResponse(conn, response, nil)

	return nil
}

func Serve() {
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
