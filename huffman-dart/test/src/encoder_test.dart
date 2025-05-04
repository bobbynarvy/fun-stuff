import 'package:huffman_dart/src/encoder.dart';
import 'package:test/test.dart';

void main() {
  test('encoder', () {
    Encoding encoding = encode("aabbbcccc");
    expect(encoding.map['a'.runes.first], equals(int.parse("10", radix: 2)));
    expect(encoding.map['b'.runes.first], equals(int.parse("11", radix: 2)));
    expect(encoding.map['c'.runes.first], equals(int.parse("0", radix: 2)));

    List<String> expectedVals = [
      '10',
      '10',
      '11',
      '11',
      '11',
      '0',
      '0',
      '0',
      '0',
    ];
    List<int> vals = encoding.vals;

    for (int i = 0; i < vals.length; i++) {
      expect(vals[i], equals(int.parse(expectedVals[i], radix: 2)));
    }
  });
}
