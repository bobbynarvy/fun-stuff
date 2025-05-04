import "encoder.dart";

String decode(Encoding encoding) {
  String result = '';

  for (int i = 0; i < encoding.vals.length; i++) {
    // TODO: handle inexistent mappings
    int charCode = encoding.map[encoding.vals[i]]!;
    result += String.fromCharCode(charCode);
  }

  return result;
}
