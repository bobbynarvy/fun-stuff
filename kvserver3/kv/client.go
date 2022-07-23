package kv

import (
	"bufio"
	"fmt"
	"net"
)

type Client struct {
	Address string
}

func (c Client) Get(key string) (string, error) {
	conn, err := net.Dial("tcp", c.Address)
	defer conn.Close()
	if err != nil {
		return "", err
	}

	fmt.Fprintf(conn, "GET %s\r\n", key)

	val, err := bufio.NewReader(conn).ReadString('\n')
	if err != nil {
		return "", err
	}

	return val, nil
}

func (c Client) Set(key string, value string) (string, error) {
	conn, err := net.Dial("tcp", c.Address)
	defer conn.Close()
	if err != nil {
		return "", err
	}

	fmt.Fprintf(conn, "SET %s %s\r\n", key, value)

	status, err := bufio.NewReader(conn).ReadString('\n')
	if err != nil {
		return "", err
	}

	return status, nil
}
