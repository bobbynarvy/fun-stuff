# huffman-cr

An ASCII text compressor that uses Huffman encoding.

## How to build

`crystal build src/huffman-cr.cr`

## Usage

Once built, run the program with `huffman-cr {arguments}`

### Encoding

`huffman-cr encode {path of text file to encode} [output path to write compressed text to]`

### Decoding

`huffman-cr decode {path of text file to decode} [output path to write decompressed text to]`
