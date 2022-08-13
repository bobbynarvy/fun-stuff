-- name: ListAuthors :many
SELECT * FROM authors
ORDER BY name;

-- name: GetAuthor :one
SELECT * FROM authors
WHERE id = ?;

-- name: ListQuotes :many
SELECT q.id, q.quote, a.name AS author
FROM quotes q
INNER JOIN authors a ON q.author_id = a.id;

-- name: GetQuote :one
SELECT q.id, q.quote, a.name AS author
FROM quotes q
INNER JOIN authors a ON q.author_id = a.id
WHERE q.id = ?;

-- name: GetQuotesByAuthor :many
SELECT q.id, q.quote, a.name AS author
FROM quotes q
INNER JOIN authors a ON q.author_id = a.id
WHERE a.id = ?;
