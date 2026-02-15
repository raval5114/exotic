class Cart {
  final int cartId;
  final int productId;
  final int variantId;
  final String name;
  final String sku;
  final String image;
  final int quantity;
  final int mrp;
  final int discount;
  final int discountType;
  final double finalPrice;
  final double totalPrice;
  final int codAvailable;
  final int freeShipping;
  final String? variantName;

  Cart({
    required this.cartId,
    required this.productId,
    required this.variantId,
    required this.name,
    required this.sku,
    required this.image,
    required this.quantity,
    required this.mrp,
    required this.discount,
    required this.discountType,
    required this.finalPrice,
    required this.totalPrice,
    required this.codAvailable,
    required this.freeShipping,
    this.variantName,
  });

  factory Cart.fromJson(Map<String, dynamic> e) {
    return Cart(
      cartId: (e['cart_id'] as num).toInt(),
      productId: (e['product_id'] as num).toInt(),
      variantId: (e['variant_id'] as num).toInt(),
      name: e['name'] ?? '',
      sku: e['sku'] ?? '',
      image: e['image'] ?? '',
      quantity: (e['quantity'] as num).toInt(),
      mrp: (e['mrp'] as num).toInt(),
      discount: (e['discount'] as num).toInt(),
      discountType: (e['discount_type'] as num).toInt(),
      finalPrice: (e['final_price'] as num).toDouble(),
      totalPrice: (e['total_price'] as num).toDouble(),
      codAvailable: (e['cod_available'] as num).toInt(),
      freeShipping: (e['free_shipping'] as num).toInt(),
      variantName: e['variant_name'],
    );
  }

  Cart copyWith({
    int? quantity,
    int? mrp,
    int? discount,
    double? finalPrice,
    double? totalPrice,
  }) {
    return Cart(
      cartId: cartId,
      productId: productId,
      variantId: variantId,
      name: name,
      sku: sku,
      image: image,
      quantity: quantity ?? this.quantity,
      mrp: mrp ?? this.mrp,
      discount: discount ?? this.discount,
      discountType: discountType,
      finalPrice: finalPrice ?? this.finalPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      codAvailable: codAvailable,
      freeShipping: freeShipping,
      variantName: variantName,
    );
  }
}
