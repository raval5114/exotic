import 'dart:convert';
import 'package:exotic/data/repositories/homescreen/categories.dart/categories.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesRepo extends ICategoriesRepo {
  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final Uri uri = Uri.parse("https://xotic.in/api/fetch_category.php");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint("Fetching Categories");
        if (data.containsKey('data') && data['data'] is List) {
          final List<dynamic> rawList = data['data'];
          return rawList
              .whereType<Map<String, dynamic>>() // Filter safely
              .toList();
        } else {
          throw Exception(
            "Malformed response: 'data' key not found or invalid format.",
          );
        }
      } else {
        throw Exception(
          "Error: ${response.statusCode}, Message: ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
