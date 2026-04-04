import 'dart:convert';
import 'package:exotic/data/repositories/searchProductPage/searchProductPage.dart';
import 'package:http/http.dart' as http;

class SearchProductTesingService extends ISearchProductRepo {
  static const String _baseUrl =
      "https://xotic.in/api/search-suggestions-mobile.php";

  @override
  Future<List<String>> fetchDiscoverData() {
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPopularData() {
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentData() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> searchProduct(String query) async {
    // We will just fetch all data here. We ignore the query parameter for the API call
    // because the server throws a 500 when `?q=` is appended to this specific endpoint.
    try {
      final response = await http.get(Uri.parse(_baseUrl));
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

  @override
  Future<Map<String, dynamic>> fetchSearchSuggestions() async {
    // Return empty for testing or rely on searchProduct depending on the implementation
    return searchProduct('');
  }
}
