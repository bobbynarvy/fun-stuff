// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.14.0

package data

import (
	"database/sql"
)

type Author struct {
	ID   int32
	Name string
}

type Quote struct {
	ID       int32
	AuthorID sql.NullInt32
	Quote    string
}
