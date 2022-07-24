package kv

import (
	"bufio"
	"errors"
	"fmt"
	"net"
	"strings"
)

type Client struct {
	Address string
}

func parseResponseString(conn net.Conn) (string, error) {
	respStr, err := bufio.NewReader(conn).ReadString('\n')
	if err != nil {
		return "", err
	}

	trimmed := strings.Trim(respStr, "\n")
	parsed := strings.Split(trimmed, " ")

	if len(parsed) == 0 {
		return "", errors.New("Response invalid")
	}

	switch parsed[0] {
	case "OK":
		return parsed[1], nil
	case "ERROR":
		return "", errors.New(strings.Join(parsed[1:], " "))
	}

	return "", errors.New("Unexpected error")
}

func (c Client) Get(key string) (string, error) {
	conn, err := net.Dial("tcp", c.Address)
	defer conn.Close()
	if err != nil {
		return "", err
	}

	fmt.Fprintf(conn, "GET %s\r\n", key)

	return parseResponseString(conn)
}

func (c Client) Set(key string, value string) (string, error) {
	conn, err := net.Dial("tcp", c.Address)
	defer conn.Close()
	if err != nil {
		return "", err
	}

	fmt.Fprintf(conn, "SET %s %s\r\n", key, value)

	return parseResponseString(conn)
}
