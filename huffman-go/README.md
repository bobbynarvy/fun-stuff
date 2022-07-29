# huffman-go

Encode and decode text using [Huffman coding](https://en.wikipedia.org/wiki/Huffman_coding).

## Usage

Once built, run the program with `huffman {subcommand}` 

### Encoding

```
huffman encode {flags} {string that you want to encode}
```

The following flags are available:

```
-file string
      path of the file to be encoded
-output string
      path of the file with the encoded text
```

### Decoding

You can then decode:

```
huffman decode {flags}
```

With the following flags:

```
-file string
      path of the file to be decoded
-output string
      path of the file with the decoded text
-print
      print the output (default true)
```
