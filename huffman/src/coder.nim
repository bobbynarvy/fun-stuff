import algorithm
import options
import tables

type
  Node = ref object
    count: int
    symbol: Option[char]
    left, right: Option[Node]

func initNodes(text: string): seq[Node] =
  var char_counts = initTable[char, int]()
  var nodes: seq[Node] = @[]

  for c in text:
    if char_counts.hasKeyOrPut(c, 1):
      char_counts[c] += 1
  
  for char, count in char_counts.pairs:
    let node = Node(count: count, 
      symbol: some(char),
      left: none(Node),
      right: none(Node))
    nodes.add(node)

  nodes

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

func encode*(text: string): string =
  var nodes = initNodes(text)
  let tree = createTree(nodes)
  
  var code = ""
  for c in text:
    let charCode = encodeChar(c, tree, "0")
    code.add(charCode.get)

  code

when isMainModule:
  let text = "Hello, world!"
  var nodes = initNodes(text)
  var tree = createTree(nodes)

  doAssert tree.count == 13
