import 'package:exotic/data/models/Homepage/elements/Items/ProductItem.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductPrice {
  final double sellingPrice;
  final double mrpPrice;
  final int discountPercentage;

  ProductPrice({
    required this.sellingPrice,
    required this.mrpPrice,
    required this.discountPercentage,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      mrpPrice: (json['mrp_price'] ?? 0).toDouble(),
      discountPercentage: json['discount_percentage'] ?? 0,
    );
  }
}

class ProductRating {
  final double average;
  final int count;

  ProductRating({required this.average, required this.count});

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}

class ProductBadges {
  final String? ribbon;
  final String? deal;
  final bool freeShipping;

  ProductBadges({this.ribbon, this.deal, required this.freeShipping});

  factory ProductBadges.fromJson(Map<String, dynamic> json) {
    return ProductBadges(
      ribbon: json['ribbon'],
      deal: json['deal'],
      freeShipping: json['free_shipping'] ?? false,
    );
  }
}

class ProductGridVertical2Item {
  final int productId;
  final String name;
  final String shortDescription;
  final String imageUrl;
  final ProductPrice price;
  final ProductRating rating;
  final ProductBadges badges;
  final String url;

  ProductGridVertical2Item({
    required this.productId,
    required this.name,
    required this.shortDescription,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.badges,
    required this.url,
  });

  factory ProductGridVertical2Item.fromJson(Map<String, dynamic> json) {
    return ProductGridVertical2Item(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: ProductPrice.fromJson(json['price'] ?? {}),
      rating: ProductRating.fromJson(json['rating'] ?? {}),
      badges: ProductBadges.fromJson(json['badges'] ?? {}),
      url: json['url'] ?? '',
    );
  }
}
