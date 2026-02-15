abstract class WishlistRepo {
  /// 📥 Fetch wishlist by customer id
  Future<Map<String, dynamic>> fetchWishlist(int cid);

  /// ➕ Add product to wishlist
  Future<bool> addWishlist(int cid, int pid);

  /// ❌ Remove product from wishlist
  Future<bool> deleteWishlist(int wishlistid);
}
