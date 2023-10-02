import 'package:morse_dart/morse_dart.dart';
import 'package:test/test.dart';

void main() {
  test('encode', () {
    expect(encode("hello world!"),
        ".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--");
  });

  test('decode', () {
    expect(decode(".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--"),
        "hello world!");
  });
}
