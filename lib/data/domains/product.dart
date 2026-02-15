import 'dart:convert';
import 'package:exotic/utils/newProductList.dart';
import 'package:http/http.dart' as http;
import 'package:exotic/data/repositories/products/products.dart';

class ProductService extends IProductsRepo {
  @override
  Future<List<Map<String, dynamic>>> fetchProductData() async {
    try {
      final response = await http.get(
        Uri.parse("https://xotic.in/api/fetch_products.php"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if "data" exists and is a list
        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
          final List<dynamic> dataList = jsonResponse['data'];
          return dataList.whereType<Map<String, dynamic>>().toList();
        } else {
          throw Exception(
            "Unexpected JSON structure: 'data' key not found or invalid",
          );
        }
      } else {
        throw Exception(
          'Failed to load product data (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching product data: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchProductForTesting() async {
    // TODO: implement fetchProductForTesting

    return products;
  }

  @override
  Future<Map<String, dynamic>> fetchProductById(String pid) async {
    try {
      final response = await http.get(
        Uri.parse('https://xotic.in/api/single_product.php?id=$pid'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load product (Status: ${response.statusCode})',
        );
      }

      final Map<String, dynamic> jsonResponse =
          json.decode(response.body) as Map<String, dynamic>;

      final status = jsonResponse['status'];

      if (status == 'success') {
        return jsonResponse;
      }

      if (status == 'error') {
        throw Exception(jsonResponse['message'] ?? 'Unknown API error');
      }

      // Safety net for unexpected API responses
      throw Exception('Unexpected response format');
    } catch (e) {
      rethrow;
    }
  }
}
