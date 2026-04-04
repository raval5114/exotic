import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  var bytes = await File('test.webp').readAsBytes();
  var dec = img.decodeImage(bytes);
  print(dec != null ? 'DECODED' : 'FAILED');
}
