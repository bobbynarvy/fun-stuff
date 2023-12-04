enum Node {
    indirect case branch(Node, Node)
    case leaf(Character, Int)

    var freqs: Int {
        switch self {
        case .leaf(_, let freq):
            return freq
        case .branch(let left, let right):
            return left.freqs + right.freqs
        }
    }

    func encode(mapping: inout [Character:String], bitStr: String = "") {
        switch self {
        case .leaf(let char, _):
            mapping[char] = bitStr
        case .branch(let left, let right):
            left.encode(mapping: &mapping, bitStr: bitStr + "0")
            right.encode(mapping: &mapping, bitStr: bitStr + "1")
        }
    }
}

func huffmanEncode(source src: String) -> ([Character: String], String) {
    // calculate frequencies of chars
    var chars: [Character: Int] = [:]
    for char in src {
        chars[char, default: 0] += 1
    }

    // create tree
    var nodes: [Node] = chars.map { Node.leaf($0, $1) }
    while nodes.count > 1 {
        nodes.sort { $0.freqs < $1.freqs }
        nodes.append(Node.branch(nodes.removeFirst(), nodes.removeFirst()))
    }

    // create bit string for each character
    var charBits: [Character: String] = [:]
    nodes[0].encode(mapping: &charBits)

    // encode the source itself
    var encoded = ""
    for char in src {
        encoded += charBits[char]!
    }

    return (charBits, encoded)
}
