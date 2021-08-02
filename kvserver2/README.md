# kvserver2

A simple in-memory key-value store over a TCP server.

## Learning goals:

- implement a TCP server in Nim, using its asynchronous model to handle requests
- use more Nim language features (e.g. `options` module)

## Usage:

`nimble build -r` will build and start a TCP server.

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
