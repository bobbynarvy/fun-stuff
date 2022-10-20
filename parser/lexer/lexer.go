//go:generate stringer -type=TokenType

package lexer

import "fmt"

type TokenType int

const (
	// Single-character tokens.
	LeftParen TokenType = iota
	RightParen
	Minus
	Plus
	Slash
	Star

	// One or two character tokens.
	Bang
	BangEqual
	EqualEqual
	Greater
	GreaterEqual
	Less
	LessEqual

	// Literals.
	String
	Number

	// Keywords.
	False
	True
	Nil
)

type Token struct {
	tokenType TokenType
	lexeme    string
}

func (token Token) String() string {
	return fmt.Sprintf("[%v: %s]", token.tokenType, token.lexeme)
}

type scanner struct {
	source  string
	start   int
	current int
	tokens  []Token
}

func newScanner(source string) scanner {
	return scanner{
		source:  source,
		start:   0,
		current: 0,
		tokens:  []Token{},
	}
}

func (s *scanner) isAtEnd() bool {
	return s.current >= len(s.source)
}

// advance consumes the next character in the source file and returns it
func (s *scanner) advance() rune {
	char := rune(s.source[s.current])
	s.current++

	return char
}

// match consumes the next character and returns it if the expected
// character is matched
func (s *scanner) match(expected rune) bool {
	if s.isAtEnd() {
		return false
	}

	if rune(s.source[s.current]) != expected {
		return false
	}

	s.current++
	return true
}

// peek looks at the current character but doesn't consume it
func (s *scanner) peek() rune {
	if s.isAtEnd() {
		return '\000'
	}

	return rune(s.source[s.current])
}

func (s *scanner) peekNext() rune {
	if s.current+1 > len(s.source) {
		return '\000'
	}

	return rune(s.source[s.current+1])
}

func (s *scanner) matchOperator(expected rune, def TokenType, alt TokenType) TokenType {
	var token TokenType
	token = def
	if s.match(expected) {
		token = alt
	}

	return token
}

func (s *scanner) addToken(tokenType TokenType) {
	text := s.source[s.start:s.current]
	token := Token{
		tokenType: tokenType,
		lexeme:    text,
	}

	s.tokens = append(s.tokens, token)
}

func (s *scanner) stringToken() error {
	for s.peek() != '"' && !s.isAtEnd() {
		s.advance()
	}

	if s.isAtEnd() {
		return fmt.Errorf("Unterminated string.")
	}

	// the closing "
	s.advance()

	// TO DO: trim surrounding quotes
	s.addToken(String)

	return nil
}

func (s *scanner) numberToken() {
	for isDigit(s.peek()) {
		s.advance()
	}

	// Look for fractional part
	if s.peek() == '.' && isDigit(s.peekNext()) {
		s.advance()

		for isDigit(s.peek()) {
			s.advance()
		}
	}

	s.addToken(Number)
}

func (s *scanner) keywordToken() error {
	for isAlpha(s.peek()) {
		s.advance()
	}

	text := s.source[s.start:s.current]
	switch text {
	case "true":
		s.addToken(True)
	case "false":
		s.addToken(False)
	case "nil":
		s.addToken(Nil)
	default:
		return fmt.Errorf("Invalid keyword: %s", text)
	}

	return nil
}

func isDigit(char rune) bool {
	return char >= '0' && char <= '9'
}

func isAlpha(char rune) bool {
	return (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z')
}

// scanToken scans the source for a single token and
// adds it to the slice of tokens in the scanner
func (s *scanner) scanToken() error {
	char := s.advance()

	switch char {
	case '(':
		s.addToken(LeftParen)
	case ')':
		s.addToken(RightParen)
	case '-':
		s.addToken(Minus)
	case '+':
		s.addToken(Plus)
	case '/':
		s.addToken(Slash)
	case '*':
		s.addToken(Star)
	case '!':
		s.addToken(s.matchOperator('=', Bang, BangEqual))
	case '<':
		s.addToken(s.matchOperator('=', Less, LessEqual))
	case '>':
		s.addToken(s.matchOperator('=', Greater, GreaterEqual))
	case '=':
		if !s.match('=') {
			return fmt.Errorf("Invalid token: =%s", string(char))
		}
		s.addToken(EqualEqual)
	case ' ', '\r', '\t', '\n': // do nothing
	case '"':
		err := s.stringToken()
		if err != nil {
			return err
		}
	default:
		if isDigit(char) {
			s.numberToken()
		} else if isAlpha(char) {
			s.keywordToken()
		} else {
			return fmt.Errorf("Unexpected character: %s", string(char))
		}
	}

	return nil
}

func ScanTokens(source string) ([]Token, error) {
	scanner := newScanner(source)

	for !scanner.isAtEnd() {
		scanner.start = scanner.current
		err := scanner.scanToken()

		if err != nil {
			return nil, err
		}
	}

	return scanner.tokens, nil
}
