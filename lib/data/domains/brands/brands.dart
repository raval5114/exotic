import 'dart:convert';

import 'package:exotic/data/repositories/brands/brands.dart';
import 'package:http/http.dart' as http;

class BrandsServices extends IBrandsRepo {
  @override
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final url = Uri.parse("https://xotic.in/api/fetch_products.php");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.whereType<Map<String, dynamic>>().toList();
        } else {
          throw Exception("API returned unexpected data format");
        }
      } else {
        throw Exception(
          "API error: ${response.statusCode} - ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      print("Error fetching brands: $e");
      rethrow;
    }
  }
}
