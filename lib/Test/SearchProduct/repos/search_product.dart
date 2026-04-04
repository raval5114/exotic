import 'dart:convert';
import 'package:exotic/data/repositories/searchProductPage/searchProductPage.dart';
import 'package:http/http.dart' as http;

class SearchProductTesingService extends ISearchProductRepo {
  static const String _baseUrl =
      "https://xotic.in/api/search-suggestions-mobile.php";
  @override
  Future<List<String>> fetchDiscoverData() {
    // TODO: implement fetchDiscoverData
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPopularData() {
    // TODO: implement fetchPopularData
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentData() {
    // TODO: implement fetchRecentData
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> searchProduct(String query) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl?q=$query"));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to load search results: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching search results: $e');
    }
  }
}
