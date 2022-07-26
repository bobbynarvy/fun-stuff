package coder

// Decode an coded message given a set of Huffman encodings.
// This implementation is not efficient.
func Decode(encodedText string, encodings []EncodingPair) string {
	code := encodedText
	decoded := ""

	for len(code) > 0 {
		for _, encoding := range encodings {
			sub := code[0:len(encoding.code)]
			if sub == encoding.code {
				decoded = decoded + string(encoding.char)
				code = code[len(encoding.code):]
			}

			if len(code) == 0 {
				break
			}
		}
	}

	return decoded
}
