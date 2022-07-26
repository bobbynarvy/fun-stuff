package coder

import (
	"testing"
)

func TestDecode(t *testing.T) {
	encodings := []EncodingPair{
		{rune('e'), "11"},
		{rune('m'), "001"},
		{rune('o'), "010"},
		{rune('r'), "0111"},
	}

	if decoded := Decode("001010011111", encodings); decoded != "more" {
		t.Errorf("incorrect decoded value; expected \"more\", got %s", decoded)
	}
}
