package main

import (
	"fmt"
	"huffman/io"
	"os"
)

func main() {
	err := io.Run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}
