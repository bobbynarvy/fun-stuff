package main

import (
	"fmt"
	"huffman/coder"
)

func main() {
	text := "hello world!"
	fmt.Println(coder.Encode(text))
}
