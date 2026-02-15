class WishlistModel {
  final int wishlistId;
  final int productId;
  final int? variantId;

  final String brandName;
  final String productName;
  final String variantName;
  final String image;

  final double mrp;
  final double discount;
  final int discountType;
  final double finalPrice;

  final bool isAvailable;

  WishlistModel({
    required this.wishlistId,
    required this.productId,
    this.variantId,
    required this.brandName,
    required this.productName,
    required this.variantName,
    required this.image,
    required this.mrp,
    required this.discount,
    required this.discountType,
    required this.finalPrice,
    required this.isAvailable,
  });

  /// 🔁 From API JSON
  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      wishlistId: (json['wishlist_id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      variantId:
          json['variant_id'] != null
              ? (json['variant_id'] as num).toInt()
              : null,

      brandName: json['brand_name'] ?? '',
      productName: json['product_name'] ?? '',
      variantName: json['variant_name'] ?? '',
      image: json['image'] ?? '',

      mrp: (json['mrp'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      discountType: (json['discount_type'] as num).toInt(),
      finalPrice: (json['final_price'] as num).toDouble(),

      isAvailable: json['is_available'] ?? false,
    );
  }

  /// 🔁 To API JSON (for add/remove if needed)
  Map<String, dynamic> toJson() {
    return {
      'wishlist_id': wishlistId,
      'product_id': productId,
      'variant_id': variantId,
      'brand_name': brandName,
      'product_name': productName,
      'variant_name': variantName,
      'image': image,
      'mrp': mrp,
      'discount': discount,
      'discount_type': discountType,
      'final_price': finalPrice,
      'is_available': isAvailable,
    };
  }
}
