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

when isMainModule:
  let text = "Hello, world!"
  var nodes = initNodes(text)
  var tree = createTree(nodes)

  doAssert tree.count == 13
