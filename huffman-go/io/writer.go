package io

import (
	"fmt"
	"huffman/coder"
	"os"
)

func WriteEncodingToFile(encoding *coder.Encoding, fileName string) {
	file, err := os.Create(fileName)
	if err != nil {
		fmt.Println(err)
	}
	defer file.Close()

	// Write the number of encoding pairs
	file.WriteString(fmt.Sprintf("%d\n", len(encoding.Pairs)))

	// Write the encoding table
	// Write one encoding pair per line, separate by space
	for _, pair := range encoding.Pairs {
		file.WriteString(fmt.Sprintf("%v %v\n", pair.Char, pair.Code))
	}

	// Write the encoded text
	file.WriteString(encoding.CodedText)

	file.Sync()
}
