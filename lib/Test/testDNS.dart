import 'dart:io';

import 'package:flutter/material.dart';

void testDNS() async {
  try {
    final result = await InternetAddress.lookup('xotic.in');
    debugPrint('✅ DNS Lookup Success: ${result.first.address}');
  } catch (e) {
    debugPrint('❌ DNS Lookup Failed: $e');
  }
}
