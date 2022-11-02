package ast

import (
	"fmt"
	"parser/lexer"
)

type ExprType int

const (
	Binary ExprType = iota
	Grouping
	Literal
	Unary
)

type Expr interface {
	String() string
	ExprType() ExprType
}

type BinaryExpr struct {
	Left     Expr
	Operator lexer.Token
	Right    Expr
}

type GroupingExpr struct {
	Expr Expr
}

type LiteralExpr struct {
	Value lexer.Token
}

type UnaryExpr struct {
	Operator lexer.Token
	Expr     Expr
}

func (e BinaryExpr) ExprType() ExprType {
	return Binary
}

func (e GroupingExpr) ExprType() ExprType {
	return Grouping
}

func (e LiteralExpr) ExprType() ExprType {
	return Literal
}

func (e UnaryExpr) ExprType() ExprType {
	return Unary
}

func parenthesize(name string, exprs ...*Expr) string {
	s := fmt.Sprintf("(%s", name)

	for _, e := range exprs {
		s += fmt.Sprintf(" %s", *e)
	}

	s += ")"
	return s
}

func (e BinaryExpr) String() string {
	return parenthesize(e.Operator.Lexeme, &e.Left, &e.Right)
}

func (e GroupingExpr) String() string {
	return parenthesize("group", &e.Expr)
}

func (e LiteralExpr) String() string {
	return e.Value.Lexeme
}

func (e UnaryExpr) String() string {
	return parenthesize(e.Operator.Lexeme, &e.Expr)
}
