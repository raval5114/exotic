import 'dart:convert';
import 'package:exotic/data/repositories/homescreen/homepage/homepage.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class HomePageRepo extends IHomePageRepo {
  @override
  Future<Map<String, dynamic>> getHomePageData({
    String slug = "Homepage",
  }) async {
    try {
      var response = await http.get(
        Uri.parse('https://xotic.in/api/elements/page.php?slug=${slug}'),
      );

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        debugPrint("Working");
        // Check if the API call was successful
        if (decoded['success'] == true && decoded['page'] != null) {
          // Extract rows from the page data
          return decoded['page'];
          // Convert to List<Map<String, dynamic>>
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load homepage data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getHomepageTabsData() async {
    final uri = Uri.parse("https://xotic.in/api/elements/pages.php");

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Failed to load homepage pages");
    }

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (decoded['success'] != true) {
      throw Exception("API returned failure");
    }

    final List pages = decoded['pages'];

    return pages
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
