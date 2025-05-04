import 'package:huffman_dart/src/encoder.dart';
import 'package:huffman_dart/src/decoder.dart';
import 'package:test/test.dart';

void main() {
  test('decoder', () {
    Map<int, int> map = {};
    map[int.parse('10', radix: 2)] = 'a'.runes.first;
    map[int.parse('11', radix: 2)] = 'b'.runes.first;
    map[int.parse('0', radix: 2)] = 'c'.runes.first;
    List<int> vals =
        [
          '10',
          '10',
          '11',
          '11',
          '11',
          '0',
          '0',
          '0',
          '0',
        ].map((bitStr) => int.parse(bitStr, radix: 2)).toList();

    Encoding encoding = Encoding(map, vals);
    String result = decode(encoding);
    expect(result, equals("aabbbcccc"));
  });
}
