package io

import (
	"fmt"
	"huffman/coder"
	"os"
)

func WriteEncodingToFile(encoding *coder.Encoding, fileName string) {
	if fileName == "" {
		fileName = "encoded.huff"
	}

	file, err := os.Create(fileName)
	if err != nil {
		fmt.Println(err)
	}
	defer file.Close()

	// Write the number of encoding pairs
	file.WriteString(fmt.Sprintf("%d\n", len(encoding.Pairs)))

	// Write one encoding pair per line, separate by comma
	for _, pair := range encoding.Pairs {
		file.WriteString(fmt.Sprintf("%v %v\n", pair.Char, pair.Code))
	}

	// Write the encoded text
	file.WriteString(encoding.CodedText)

	file.Sync()
}
