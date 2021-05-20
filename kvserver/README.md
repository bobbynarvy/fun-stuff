# kvserver

A simple in-memory key-value store over a TCP server.

## Learning goals:

- implement a TCP server in Rust
- use more Rust language features (e.g. enums)

## Usage:

`cargo run` will start a TCP server.

Using a telnet client, the following requests are available:

### SET

```
SET hello world
```

### GET

```
GET hello
```

All other requests will return an error.