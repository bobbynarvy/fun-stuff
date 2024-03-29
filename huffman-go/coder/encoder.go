package coder

import (
	"sort"
)

type Node struct {
	count  int
	symbol rune
	left   *Node
	right  *Node
}

type EncodingPair struct {
	Char rune
	Code string
}

type Encoding struct {
	CodedText string
	Pairs     []EncodingPair
}

func initNodes(text string) []Node {
	nodes := []Node{}
	charCounts := make(map[rune]int)

	for _, char := range text {
		if _, ok := charCounts[char]; !ok {
			charCounts[char] = 0
		}
		charCounts[char] += 1
	}

	for char, count := range charCounts {
		node := Node{count, char, nil, nil}
		nodes = append(nodes, node)
	}

	return nodes
}

func mergeNodes(left *Node, right *Node) Node {
	count := left.count + right.count
	return Node{count, 0, left, right}
}

func createTree(nodes []Node) Node {
	for len(nodes) > 1 {
		sort.Slice(nodes, func(i, j int) bool {
			return nodes[i].count < nodes[j].count
		})

		left := nodes[0]
		nodes = nodes[1:]
		right := nodes[0]
		nodes = nodes[1:]

		newNode := mergeNodes(&left, &right)
		nodes = append(nodes, newNode)
	}

	return nodes[0]
}

func encodeChar(c rune, tree *Node, acc string) string {
	if tree.symbol != 0 && tree.symbol == c {
		return acc
	}

	if tree.left == nil && tree.right == nil {
		return ""
	}

	if left := encodeChar(c, tree.left, acc+"0"); left != "" {
		return left
	}

	return encodeChar(c, tree.right, acc+"1")
}

func Encode(text string) Encoding {
	nodes := initNodes(text)
	tree := createTree(nodes)
	encodingMap := make(map[rune]string)
	codedText := ""
	pairs := []EncodingPair{}

	for _, char := range text {
		if _, ok := encodingMap[char]; !ok {
			charCode := encodeChar(char, &tree, "0")
			codedText += charCode
			encodingMap[char] = charCode
			pairs = append(pairs, EncodingPair{char, charCode})
		} else {
			charCode := encodingMap[char]
			codedText += charCode
		}
	}

	return Encoding{codedText, pairs}
}
