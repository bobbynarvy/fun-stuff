# kvserver3

A simple in-memory key-value store over a TCP server.

## Learning goals:

- learn Go and use features in its standard library
- implement a TCP server in Go

## Usage

```bash
go run .
```

Starts the key-value server in `localhost:8000`

### Client

A client library is available to use:

```go
client := Client{"localhost:8080"}

_, err := client.Set("hello", "world")

result, err := client.Get("hello")
// result == world
// ...
```
