import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exotic/data/repositories/products/fetchProduct.dart';

class FetchProductServices implements ProductsRepository {
  @override
  Future<List<Map<String, dynamic>>> fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse("http://exotic.in/api/fetch_product.php"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
          final List<dynamic> dataList = jsonResponse['data'];
          return dataList.cast<Map<String, dynamic>>();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
