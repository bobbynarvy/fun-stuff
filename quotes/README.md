# quotes

A simple web service that provides inspiring quotations.

## Requirements

- Go 1.18
- An installation of [sqlc](https://docs.sqlc.dev/en/stable/overview/install.html)
- Docker

## Usage

A `docker-compose.yaml` file is available and is used to start a MySQL database
preloaded with quotations. Start it with:

```
docker compose up -d
```

Start the server with `go run .` in the root directory.

### Routes

**`GET /quotes`**

Returns a list of inspiring quotations

Query parameters:

- `author-id` - returns the quotes by the author with id supplied

**`GET /authors`**

Returns a list of authors

**`GET /authors/{id}`**

Returns an author with their quotes
