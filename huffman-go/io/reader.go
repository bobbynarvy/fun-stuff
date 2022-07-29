package io

import (
	"bufio"
	"fmt"
	"huffman/coder"
	"os"
	"strconv"
	"strings"
)

func DecodeFromFile(fileName string) (string, error) {
	file, err := os.Open(fileName)
	if err != nil {
		return "", err
	}

	//  read first line to get the number of encoding pairs
	scanner := bufio.NewScanner(file)
	scanner.Scan()
	numPairs, _ := strconv.Atoi(scanner.Text())

	// get the encoding pairs
	pairs := []coder.EncodingPair{}
	for i := 1; i <= numPairs; i++ {
		scanner.Scan()
		pairString := scanner.Text()
		charCode := strings.Split(pairString, " ")
		char, _ := strconv.Atoi(charCode[0])
		encodingPair := coder.EncodingPair{
			Char: rune(char),
			Code: charCode[1],
		}
		pairs = append(pairs, encodingPair)
	}

	// get the encoded text
	scanner.Scan()
	codedText := scanner.Text()

	decoded := coder.Decode(codedText, pairs)

	fmt.Printf("Decoded text: %s\n", decoded)

	return decoded, nil
}
