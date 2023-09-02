// Code generated by "stringer -type=TokenType"; DO NOT EDIT.

package lexer

import "strconv"

func _() {
	// An "invalid array index" compiler error signifies that the constant values have changed.
	// Re-run the stringer command to generate them again.
	var x [1]struct{}
	_ = x[LeftParen-0]
	_ = x[RightParen-1]
	_ = x[Minus-2]
	_ = x[Plus-3]
	_ = x[Slash-4]
	_ = x[Star-5]
	_ = x[Bang-6]
	_ = x[BangEqual-7]
	_ = x[EqualEqual-8]
	_ = x[Greater-9]
	_ = x[GreaterEqual-10]
	_ = x[Less-11]
	_ = x[LessEqual-12]
	_ = x[String-13]
	_ = x[Number-14]
	_ = x[False-15]
	_ = x[True-16]
	_ = x[Nil-17]
	_ = x[Eof-18]
}

const _TokenType_name = "LeftParenRightParenMinusPlusSlashStarBangBangEqualEqualEqualGreaterGreaterEqualLessLessEqualStringNumberFalseTrueNilEof"

var _TokenType_index = [...]uint8{0, 9, 19, 24, 28, 33, 37, 41, 50, 60, 67, 79, 83, 92, 98, 104, 109, 113, 116, 119}

func (i TokenType) String() string {
	if i < 0 || i >= TokenType(len(_TokenType_index)-1) {
		return "TokenType(" + strconv.FormatInt(int64(i), 10) + ")"
	}
	return _TokenType_name[_TokenType_index[i]:_TokenType_index[i+1]]
}