import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exotic/data/repositories/productViewer/IProductViewerRepo.dart';

class ProductViewerRepo extends IProductViewerRepo {
  static const String baseUrl = "https://xotic.in/api";

  @override
  Future<Map<String, dynamic>> fetchProductDetails(String url) async {
    try {
      final String fullUrl;
      if (url.startsWith('http://') || url.startsWith('https://')) {
        fullUrl = url;
      } else {
        final String safeUrl = url.startsWith('/') ? url : '/$url';
        fullUrl = baseUrl + safeUrl;
      }
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['results'] != null && data['results']['products'] != null) {
          if ((data['results']['products'] as List).isEmpty) {
            throw Exception("No products found");
          }
        }
        return data;
      } else {
        throw Exception(
          "Failed to load product details: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("ProductViewer Error: $e");
      rethrow;
    }
  }
}
