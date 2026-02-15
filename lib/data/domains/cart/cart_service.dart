import 'dart:convert';
import 'package:exotic/data/repositories/cart/cart.dart';
import 'package:http/http.dart' as http;

class CartService extends ICartRepo {
  @override
  Future<bool> addToCart(int cid, int pid, int? pv_id, int quantity) async {
    try {
      final Map<String, String> body = {
        'c_id': cid.toString(),
        'p_id': pid.toString(),
        'quantity': quantity.toString(),
      };

      // 👇 ONLY send pv_id when it exists
      if (pv_id != null) {
        body['pv_id'] = pv_id.toString();
      }

      final response = await http.post(
        Uri.parse('https://xotic.in/api/cart/cart_add.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},

        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error at cart page: ${e}");
      rethrow;
    }
  }

  @override
  Future<bool> cartDelete(int cartId) async {
    try {
      Map<String, dynamic> body = {'cart_id': cartId.toString()};
      final response = await http.post(
        Uri.parse('https://xotic.in/api/cart/cart_delete.php'),
        headers: {'content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getFromCart(int cid) async {
    try {
      final response = await http.post(
        Uri.parse('https://xotic.in/api/cart/cart_get.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'c_id': cid.toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Failed to fetch cart. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  /// action must be either "increase" or "decrease"
  Future<bool> updateInCart(String cartId, String action) async {
    try {
      assert(
        action == 'increase' || action == 'decrease',
        'action must be either increase or decrease',
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://xotic.in/api/cart/cart_update.php'),
      );

      request.fields.addAll({'cart_id': cartId, 'action': action});

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // Optional: log or parse responseBody if needed
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('updateCart error: $e');
      return false;
    }
  }
}
