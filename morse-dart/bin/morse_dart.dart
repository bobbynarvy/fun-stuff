import 'dart:io';

import 'package:morse_dart/morse_dart.dart' as morse;

void main(List<String> arguments) {
  if (arguments.length == 0) {
    stderr.write('Error: First argument should be "encode" or "decode"\n');
    return;
  }

  var op = arguments[0];

  if (op == 'encode') {
    print(morse.encode(arguments.skip(1).join(' ')));
  } else if (op == 'decode') {
    print(morse.decode(arguments.skip(1).join(' ')));
  } else {
    stderr.write('Error: Invalid operation\n');
  }
}
