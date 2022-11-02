package rdparser

import (
	"fmt"
	"parser/ast"
	"parser/lexer"
)

type Parser struct {
	tokens  []lexer.Token
	current int
}

func NewParser(tokens []lexer.Token) Parser {
	return Parser{
		tokens:  tokens,
		current: 0,
	}
}

func (p *Parser) peek() lexer.Token {
	return p.tokens[p.current]
}

func (p *Parser) previous() lexer.Token {
	return p.tokens[p.current-1]
}

func (p *Parser) isAtEnd() bool {
	return p.peek().TokenType == lexer.Eof
}

func (p *Parser) check(tokenType lexer.TokenType) bool {
	if p.isAtEnd() {
		return false
	}

	return p.peek().TokenType == tokenType
}

func (p *Parser) advance() lexer.Token {
	if !p.isAtEnd() {
		p.current++
	}

	return p.previous()
}

func (p *Parser) match(types ...lexer.TokenType) bool {
	for _, tokenType := range types {
		if p.check(tokenType) {
			p.advance()
			return true
		}
	}

	return false
}

func (p *Parser) consume(tokenType lexer.TokenType, message string) (lexer.Token, error) {
	if p.check(tokenType) {
		return p.advance(), nil
	}

	return lexer.Token{}, fmt.Errorf(message)
}

func (p *Parser) primary() ast.Expr {
	if p.match(lexer.False, lexer.True, lexer.Nil, lexer.Number, lexer.String) {
		return ast.LiteralExpr{
			Value: p.previous(),
		}
	}
	if p.match(lexer.LeftParen) {
		expr := p.expression()
		// TO DO: error from this should reach top
		p.consume(lexer.RightParen, "Expect ')' after expression.")
		return ast.GroupingExpr{
			Expr: expr,
		}
	}

	// TO DO: This should be an error
	return nil
}

func (p *Parser) unary() ast.Expr {
	if p.match(lexer.Bang, lexer.Minus) {
		operator := p.previous()
		right := p.unary()
		return ast.UnaryExpr{
			Operator: operator,
			Expr:     right,
		}
	}

	return p.primary()
}

func (p *Parser) factor() ast.Expr {
	expr := p.unary()

	for p.match(lexer.Slash, lexer.Star) {
		operator := p.previous()
		right := p.unary()
		expr = ast.BinaryExpr{
			Left:     expr,
			Operator: operator,
			Right:    right,
		}
	}

	return expr
}

func (p *Parser) term() ast.Expr {
	expr := p.factor()

	for p.match(lexer.Minus, lexer.Plus) {
		operator := p.previous()
		right := p.factor()
		expr = ast.BinaryExpr{
			Left:     expr,
			Operator: operator,
			Right:    right,
		}
	}

	return expr
}

func (p *Parser) comparison() ast.Expr {
	expr := p.term()

	for p.match(lexer.Greater, lexer.GreaterEqual, lexer.Less, lexer.LessEqual) {
		operator := p.previous()
		right := p.term()
		expr = ast.BinaryExpr{
			Left:     expr,
			Operator: operator,
			Right:    right,
		}
	}

	return expr
}

func (p *Parser) equality() ast.Expr {
	expr := p.comparison()

	for p.match(lexer.BangEqual, lexer.EqualEqual) {
		operator := p.previous()
		right := p.comparison()
		expr = ast.BinaryExpr{
			Left:     expr,
			Operator: operator,
			Right:    right,
		}
	}

	return expr
}

func (p *Parser) expression() ast.Expr {
	return p.equality()
}

func (p *Parser) Parse() ast.Expr {
	return p.expression()
}
