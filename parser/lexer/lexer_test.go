package lexer

import (
	"testing"
)

func TestScanTokens(t *testing.T) {
	src := "1 + 2.2 > 0"
	tokens, _ := ScanTokens(src)

	expectedTokens := []TokenType{Number, Plus, Number, Greater, Number}
	for i, token := range tokens {
		if token.tokenType != expectedTokens[i] {
			t.Errorf("Expected token: %s, received %s", expectedTokens[i], token.tokenType)
		}
	}
}

func TestInvalidToken(t *testing.T) {
	src := "1 + $"

	_, err := ScanTokens(src)

	if err == nil {
		t.Errorf("Expected error")
	}
	if err.Error() != "Unexpected character: $" {
		t.Errorf("Wrong error, received: %s", err)
	}
}

func TestScanString(t *testing.T) {
	src := "\"hello man\""
	tokens, _ := ScanTokens(src)
	token := tokens[0]

	if token.tokenType != String {
		t.Errorf("Token should be string, received %s", token.tokenType)
	}
}

func TestScanUnterminatedString(t *testing.T) {
	src := "\"hello man"
	_, err := ScanTokens(src)

	if err == nil {
		t.Errorf("Expected error")
	}
	if err.Error() != "Unterminated string." {
		t.Errorf("Wrong error, received: %s", err)
	}
}

func TestScanKeywords(t *testing.T) {
	src := "true != false"
	tokens, _ := ScanTokens(src)

	expectedTokens := []TokenType{True, BangEqual, False}
	for i, token := range tokens {
		if token.tokenType != expectedTokens[i] {
			t.Errorf("Expected token: %s, received %s", expectedTokens[i], token.tokenType)
		}
	}
}
