# parser

An arithmetic expression parser, as described in
Robert Nystrom's book, [Crafting Interpreters](https://craftinginterpreters.com/).

This project contains a lexer, parser and an AST representation of the expression grammar.
These are described in chapters 4, 5 and 6 of the book.

## Usage

```go
package main

import (
  "fmt"
  "parser/lexer"
  "parser/rdparser"
)

func main() {
  source := "(1 + 1) <= 3 > 2"
  tokens, error := lexer.ScanTokens(source)

  if error != nil {
          fmt.Println(error)
          return
  }

  fmt.Println("tokens:", tokens)
  parser := rdparser.NewParser(tokens)
  ast := parser.Parse()

  fmt.Printf("%s\n", ast)
}
```
