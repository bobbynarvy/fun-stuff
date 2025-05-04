Encoding encode(String src) {
  final Map<int, int> countMap = {};

  for (var rune in src.runes) {
    // Check if a rune is an ASCII character
    if (rune > 127) {
      throw Exception('Only ASCII characters are allowed');
    }

    // Update the frequency
    countMap.update(rune, (count) => count + 1, ifAbsent: () => 1);
  }

  // Create the root node
  List<Node> nodes =
      countMap.entries.map((entry) => Node(entry.key, entry.value)).toList();
  while (nodes.length > 1) {
    nodes.sort((a, b) => a.freq.compareTo(b.freq));
    nodes.add(Node.fromNodes(nodes.removeAt(0), nodes.removeAt(0)));
  }
  Node rootNode = nodes.removeLast();

  // Get the encodings starting from the root node
  Map<int, int> encMap = {};
  rootNode.getCode(encMap, 0);

  // Create the Encoding result
  List<int> encodedValues = src.runes.map((rune) => encMap[rune]!).toList();
  return Encoding(encMap, encodedValues);
}

final class Encoding {
  // A map of ASCII rune to its encoded value
  final Map<int, int> map;

  // The encoded bits as a List
  final List<int> vals;

  Encoding(this.map, this.vals);
}

final class Node {
  int? char;
  late int freq;
  Node? _left;
  Node? _right;

  Node(this.char, this.freq);

  Node.fromNodes(Node left, Node right) {
    _left = left;
    _right = right;
    freq = left.freq + right.freq;
  }

  void getCode(Map<int, int> map, int bits) {
    Node? left = _left;
    Node? right = _right;

    if (left != null) {
      left.getCode(map, bits << 1);
    }
    if (right != null) {
      right.getCode(map, (bits << 1) | 1);
    }

    if (char != null) {
      map[char!] = bits;
    }
  }
}
