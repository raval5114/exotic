abstract class ICartRepo {
  Future<bool> addToCart(int cid, int pid, int pv_id, int quantity);
  Future<Map<String, dynamic>> getFromCart(int cid);
  Future<bool> updateInCart(String cartid, String action);
  Future<bool> cartDelete(int cartId);
}
