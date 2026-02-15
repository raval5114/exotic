import 'dart:convert';

import 'package:exotic/data/repositories/homescreen/homepage/homepage.dart';
import 'package:http/http.dart' as http;

class HomepageService implements IHomepageRepo {
  @override
  Future<Map<String, dynamic>> getHomePageData() async {
    try {
      var response = await http.get(
        Uri.parse('https://xotic.in/api/elements/page.php?slug=homepage'),
      );

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

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
}
