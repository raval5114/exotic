import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exotic/data/repositories/searchProductPage/searchProductPage.dart';
import 'package:exotic/utils/searchProduct.dart';

class SearchproductRepo extends ISearchProductRepo {
  static const String _baseUrl = 'https://xotic.in/api/search_products.php';

  @override
  Future<List<Map<String, dynamic>>> fetchRecentData() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      return recentSearchData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPopularData() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      return popularProducts;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchDiscoverData() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      return discoverStrings;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchProduct(String query) async {
    try {
      final uri = Uri.parse('$_baseUrl?q=$query');

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Search API failed with status ${response.statusCode}');
      }

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (decoded['success'] != true) {
        print("Working");
        throw Exception('Search API returned success=false');
      }

      final results = decoded['results'];
      if (results == null || results['products'] == null) {
        return [];
      }

      final List products = results['products'];

      return products
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
