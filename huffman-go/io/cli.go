package io

import (
	"errors"
	"flag"
	"fmt"
	"huffman/coder"
	"io/ioutil"
	"os"
	"strings"
)

func encode(cmd *flag.FlagSet) error {
	file := cmd.String("file", "", "path of the file to be encoded")
	output := cmd.String("output", "", "path of the file with the encoded text")
	strArgs := cmd.Args()

	cmd.Parse(os.Args[2:])

	if *file == "" && len(strArgs) == 0 {
		return errors.New("No file flag or string arguments set.")
	}

	fileName := "encoded.huff"
	if *output != "" {
		fileName = *output
	}

	textToEncode := strings.Join(strArgs, " ")
	if *file != "" {
		content, err := ioutil.ReadFile(*file)
		if err != nil {
			return err
		}

		textToEncode = string(content)
	}

	encoding := coder.Encode(textToEncode)
	WriteEncodingToFile(&encoding, fileName)

	fmt.Printf("Encoding complete. Saved to %s\n", fileName)

	return nil
}

func decode(cmd *flag.FlagSet) error {
	file := cmd.String("file", "", "path of the file to be decoded")
	output := cmd.String("output", "", "path of the file with the decoded text")
	printOut := cmd.Bool("print", true, "print the output")
	cmd.Parse(os.Args[2:])

	_, err := os.Stat("encoded.huff")
	if *file == "" && errors.Is(err, os.ErrNotExist) {
		return errors.New("No file to decode.")
	}

	fileName := "encoded.huff"
	if *file != "" {
		fileName = *file
	}

	decoded, err := DecodeFromFile(fileName)
	if err != nil {
		return err
	}

	if *output != "" {
		file, err := os.Create(*output)
		if err != nil {
			return err
		}
		defer file.Close()

		_, err = file.WriteString(decoded)
		if err != nil {
			return err
		}

		fmt.Printf("Decoding complete. Saved to %s\n", *output)
	}

	if *printOut {
		fmt.Println(decoded)
	}

	return nil
}

func Run() error {
	encodeCmd := flag.NewFlagSet("encode", flag.ExitOnError)
	decodeCmd := flag.NewFlagSet("decode", flag.ExitOnError)

	if len(os.Args) < 2 {
		return errors.New("Expected 'encode' or 'decode' subcommands")
	}

	switch os.Args[1] {
	case "encode":
		return encode(encodeCmd)
	case "decode":
		return decode(decodeCmd)
	default:
		return errors.New("Invalid operation. Use 'encode' or 'decode'")
	}
}
