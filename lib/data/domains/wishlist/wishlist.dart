import 'dart:async';
import 'dart:convert';
import 'package:exotic/data/repositories/wishlist/wishlist.dart';
import 'package:http/http.dart' as http;

class WishlistService implements WishlistRepo {
  static const String _baseUrl = 'https://xotic.in/api/wishlist';

  @override
  Future<Map<String, dynamic>> fetchWishlist(int cid) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/wishlist_get.php'),
    );

    request.fields['c_id'] = cid.toString();

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Wishlist fetch failed');
    }

    final decoded = jsonDecode(responseBody);

    if (decoded['status'] != true) {
      throw Exception(decoded['message'] ?? 'Wishlist error');
    }

    return decoded;
  }

  @override
  Future<bool> addWishlist(int cid, int pid) async {
    try {
      final uri = Uri.parse('$_baseUrl/wishlist_add.php');

      final response = await http
          .post(uri, body: {'c_id': cid.toString(), 'p_id': pid.toString()})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return false;
      }

      final decoded = jsonDecode(response.body);

      /// Example expected response:
      /// { "success": true, "message": "Added to wishlist" }
      if (decoded is Map<String, dynamic>) {
        return decoded['success'] == true;
      }

      return false;
    } on TimeoutException {
      // Request took too long
      return false;
    } catch (e) {
      // Log error in production
      return false;
    }
  }

  @override
  Future<bool> deleteWishlist(int wishlistId) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/wishlist_delete.php'),
      );

      request.fields['wishlist_id'] = wishlistId.toString();

      final response = await request.send();

      if (response.statusCode != 200) return false;

      final responseBody = await response.stream.bytesToString();
      final decoded = jsonDecode(responseBody);
      print("Yas its working");
      return decoded['status'] == true;
    } catch (e) {
      return false;
    }
  }
}
