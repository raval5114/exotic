import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exotic/data/repositories/searchProductPage/searchProductPage.dart';
import 'package:exotic/utils/searchProduct.dart';

class SearchproductRepo extends ISearchProductRepo {
  @override
  Future<List<Map<String, dynamic>>> fetchRecentData() async {
    return recentSearchData;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPopularData() async {
    return popularProducts;
  }

  @override
  Future<List<String>> fetchDiscoverData() async {
    return discoverStrings;
  }

  @override
  Future<Map<String, dynamic>> searchProduct(String query) async {
    try {
      final response = await http.get(
        Uri.parse("https://xotic.in/api/search_products.php?q=$query"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Prepend base URL to images if they are just filenames
        if (data['success'] == true &&
            data['results'] != null &&
            data['results']['products'] != null) {
          final List products = data['results']['products'];
          for (var p in products) {
            if (p['image'] != null &&
                p['image'].toString().isNotEmpty &&
                !p['image'].toString().startsWith('http')) {
              p['image'] =
                  "https://xotic.in/UploadImages/Variant/${p['image']}";
            }
          }
        }

        return data;
      } else {
        throw Exception(
          "Failed to load search results: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Search Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchSearchedProducts(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Prepend base URL to images if they are just filenames
        if (data['success'] == true &&
            data['results'] != null &&
            data['results']['products'] != null) {
          final List products = data['results']['products'];
          for (var p in products) {
            if (p['image'] != null &&
                p['image'].toString().isNotEmpty &&
                !p['image'].toString().startsWith('http')) {
              p['image'] =
                  "https://xotic.in/UploadImages/Variant/${p['image']}";
            }
          }
        }

        return data;
      } else {
        throw Exception(
          "Failed to load search results: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Search Error: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchSearchSuggestions() async {
    try {
      final response = await http.get(
        Uri.parse("https://xotic.in/api/search-suggestions-mobile.php"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          "Failed to load search suggestions: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Search Suggestions Error: $e");
      rethrow;
    }
  }
}
