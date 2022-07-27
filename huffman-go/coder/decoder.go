package coder

// Decode an coded message given a set of Huffman encodings.
// This implementation is not efficient.
func Decode(encodedText string, encodings []EncodingPair) string {
	code := encodedText
	decoded := ""

	for len(code) > 0 {
		for _, encoding := range encodings {
			sub := code[0:len(encoding.Code)]
			if sub == encoding.Code {
				decoded = decoded + string(encoding.Char)
				code = code[len(encoding.Code):]
			}

			if len(code) == 0 {
				break
			}
		}
	}

	return decoded
}
