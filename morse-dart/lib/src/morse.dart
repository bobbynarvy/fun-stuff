import 'mapping.dart';

String encode(String message) {
  var encoded = '';
  message.runes.forEach((c) {
    encoded = encoded + charCodeMap[String.fromCharCode(c)] + ' ';
  });
  encoded = encoded.trimRight();
  return encoded;
}

String decode(String codedMessage) {
  var decoded = '';
  var codes = codedMessage.split(' ');
  codes.forEach((code) {
    decoded = decoded + codeCharMap[code];
  });
  return decoded;
}
