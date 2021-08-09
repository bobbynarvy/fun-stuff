import algorithm
import options
import tables

type
  Node = ref object
    count: int
    symbol: Option[char]
    left, right: Option[Node]
  Encoding = (char, string)

func initNodes(text: string): seq[Node] =
  var char_counts = initTable[char, int]()

  for c in text:
    if char_counts.hasKeyOrPut(c, 1):
      char_counts[c] += 1
  
  for char, count in char_counts.pairs:
    let node = Node(count: count, 
      symbol: some(char),
      left: none(Node),
      right: none(Node))
    result.add(node)

func mergeNodes(left: Node, right: Node): Node =
  Node(count: left.count + right.count,
    symbol: none(char),
    left: some(left),
    right: some(right))

func createTree(nodes: var seq[Node]): Node =
  while nodes.len > 1:
    nodes.sort(proc (a, b: Node): int = cmp(a.count, b.count))
    
    let left = nodes[0]
    nodes.delete(0)
    let right = nodes[0]
    nodes.delete(0)

    let newNode = mergeNodes(left, right)
    nodes.add(newNode)

  nodes[0]

func encodeChar(c: char, tree: Node, acc: string): Option[string] =
  if tree.symbol.isSome and tree.symbol.get == c:
    return some(acc)

  if tree.left.isSome:
    let left = encodeChar(c, tree.left.get, acc & "0")

    if left.isSome:
      return left

  if tree.right.isSome:
    let right = encodeChar(c, tree.right.get, acc & "1")

    if right.isSome:
      return right

  return none(string)

# return the encoded string and table of encodings
func encode*(text: string): (string, seq[Encoding]) =
  var nodes = initNodes(text)
  let tree = createTree(nodes)
  var encodingTable = initTable[char, string]()
  var code = ""
  var encodings: seq[Encoding] = @[]

  for c in text:
    if not encodingTable.hasKey(c):
      let charCode = encodeChar(c, tree, "0").get
      code.add(charCode)
      encodingTable[c] = charCode
      encodings.add((c, charCode))
    else:
      let charCode = encodingTable[c]
      code.add(charCode)

  (code, encodings)

func insertNode(node: Node,c: char, bitstring: string) =
  if bitstring.len == 1:
    if bitstring == "0":
      node.left = some(Node(count: 0, symbol: some(c), left: none(Node), right: none(Node)))
    else:
      node.right = some(Node(count: 0, symbol: some(c), left: none(Node), right: none(Node)))
  else:
    if bitstring[0] == '0':
      if node.left.isNone:
        node.left = some(Node(count: 0, symbol: none(char), left: none(Node), right: none(Node)))
      insertNode(node.left.get, c, bitstring.substr(1))
    else:
      if node.right.isNone:
        node.right = some(Node(count: 0, symbol: none(char), left: none(Node), right: none(Node)))
      insertNode(node.right.get, c, bitstring.substr(1))

func createTree(encodings: seq[Encoding]): Node =
  var encodings = encodings

  # The root node will always be empty.
  # Count doesn't matter for decoding.
  result = Node(count: 0, symbol: none(char), left: none(Node), right: none(Node))

  # sort by string length to guarantee traversal
  # from root to lowest level
  encodings.sort(proc (a, b: Encoding): int = cmp(a[1].len, b[1].len))

  # insert nodes from root node
  for encoding in encodings:
    insertNode(result, encoding[0], encoding[1])

# recursively look for the char in the encoded string;
# return the char and the remaining encoded string
func findChar(node: Node, code: string): (char, string) =
  if node.left == none(Node) and node.right == none(Node):
    result = (node.symbol.get, code)
  else:
    let bit = code[0] 
    let nextNode = if bit == '0': node.left.get else: node.right.get
    result = findChar(nextNode, code.substr(1))

func decode*(code: string, encodings: seq[Encoding]): string =
  let root = createTree(encodings)
  var remainingCode = code  

  while remainingCode.len != 0:
    let (c, rem) = findChar(root, remainingCode)
    remainingCode = rem 
    result.add(c)

when isMainModule:
  let text = "Hello, world!"
  var nodes = initNodes(text)
  var tree = createTree(nodes)

  doAssert tree.count == 13

  var encodings: seq[Encoding] = @[('B', "10"), ('C', "11"), ('A', "0")]
  let root = createTree(encodings)
  let left = root.left.get[]
  let right = root.right.get[]

  doAssert left.symbol == some('A')
  doAssert right.left.get[].symbol == some('B')
  doAssert right.right.get[].symbol == some('C')

  doAssert findChar(root, "0") == ('A', "")
  doAssert findChar(root, "110") == ('C', "0")

  doAssert decode("11010011", encodings) == "CABAC"

  let (code, encodingTable) = encode(text)
  let decoded = decode(code, encodingTable)
  doAssert decoded == text
