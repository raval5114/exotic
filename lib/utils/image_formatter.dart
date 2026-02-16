import 'dart:convert';
import 'dart:typed_data';

Uint8List base64ToBytes(String base64String) {
  final cleaned = cleanBase64(base64String);
  return base64Decode(cleaned);
}

String cleanBase64(String base64String) {
  if (base64String.contains(',')) {
    return base64String.split(',').last;
  }
  return base64String;
}
