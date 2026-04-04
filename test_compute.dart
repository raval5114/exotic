import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
void main() async {
  var bytes = await File('test.webp').readAsBytes();
  var decoded = await compute(img.decodeImage, bytes);
  var pngBytes = await compute(img.encodePng, decoded!);
  print('PNGBYTES LENGTH: ${pngBytes.length}');
}
