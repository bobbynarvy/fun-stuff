package coder

import (
	"testing"
)

func TestInitNodes(t *testing.T) {
	text := "Hello"
	nodes := initNodes(text)

	if len(nodes) != 4 {
		t.Errorf("nodes length should be 4; got %d", len(nodes))
	}

	assertNodeCount := func(node *Node, count int) {
		if node.count != count {
			t.Errorf("node count should be %d; got %d", count, node.count)
		}
	}

	for _, node := range nodes {
		char := string(node.symbol)
		switch char {
		case "H":
			assertNodeCount(&node, 1)
		case "l":
			assertNodeCount(&node, 2)
		}
	}
}

func TestCreateTree(t *testing.T) {
	text := "Hello world!"
	nodes := initNodes(text)
	tree := createTree(nodes)

	if tree.count != 12 {
		t.Errorf("createTree(nodes) = %d; want 12", tree.count)
	}
}

func TestEncode(t *testing.T) {
	encoding := Encode("aabbbcccc")

	assertPairCode := func(pair *EncodingPair, code string) {
		if code != pair.code {
			t.Errorf("incorrect encoding for %s; expected %s, got %s", string(pair.char), code, pair.code)
		}
	}

	for _, pair := range encoding.pairs {
		switch char := string(pair.char); char {
		case "a":
			assertPairCode(&pair, "010")
		case "b":
			assertPairCode(&pair, "011")
		case "c":
			assertPairCode(&pair, "00")

		}
	}
}
