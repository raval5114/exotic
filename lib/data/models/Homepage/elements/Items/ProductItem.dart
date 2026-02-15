import 'package:equatable/equatable.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Price extends Equatable {
  final double sellingPrice;
  final int mrpPrice;
  final int discountPercentage;

  const Price({
    required this.sellingPrice,
    required this.mrpPrice,
    required this.discountPercentage,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      sellingPrice: (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      mrpPrice: (json['mrp_price'] as num?)?.toInt() ?? 0,
      discountPercentage: (json['discount_percentage'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selling_price': sellingPrice,
      'mrp_price': mrpPrice,
      'discount_percentage': discountPercentage,
    };
  }

  Price copyWith({
    double? sellingPrice,
    int? mrpPrice,
    int? discountPercentage,
  }) {
    return Price(
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrpPrice: mrpPrice ?? this.mrpPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }

  @override
  List<Object?> get props => [sellingPrice, mrpPrice, discountPercentage];
}

class Rating extends Equatable {
  final String average;
  final String count;

  const Rating({required this.average, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: json['average']?.toString() ?? '0',
      count: json['count']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {'average': average, 'count': count};
  }

  Rating copyWith({String? average, String? count}) {
    return Rating(average: average ?? this.average, count: count ?? this.count);
  }

  @override
  List<Object?> get props => [average, count];
}

class Badges extends Equatable {
  final String ribbon;
  final String deal;
  final bool freeShipping;

  const Badges({
    required this.ribbon,
    required this.deal,
    required this.freeShipping,
  });

  factory Badges.fromJson(Map<String, dynamic> json) {
    return Badges(
      ribbon: json['ribbon'] ?? '',
      deal: json['deal'] ?? '',
      freeShipping: json['free_shipping'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'ribbon': ribbon, 'deal': deal, 'free_shipping': freeShipping};
  }

  Badges copyWith({String? ribbon, String? deal, bool? freeShipping}) {
    return Badges(
      ribbon: ribbon ?? this.ribbon,
      deal: deal ?? this.deal,
      freeShipping: freeShipping ?? this.freeShipping,
    );
  }

  @override
  List<Object?> get props => [ribbon, deal, freeShipping];
}

class ProductItem extends Equatable implements Items {
  final int productId;
  final String name;
  final String shortDescription;
  final String imageUrl;
  final Price price;
  final Rating rating;
  final Badges badges;
  final String url;

  const ProductItem({
    required this.productId,
    required this.name,
    required this.shortDescription,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.badges,
    required this.url,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: Price.fromJson(json['price'] ?? {}),
      rating: Rating.fromJson(json['rating'] ?? {}),
      badges: Badges.fromJson(json['badges'] ?? {}),
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'short_description': shortDescription,
      'image_url': imageUrl,
      'price': price.toJson(),
      'rating': rating.toJson(),
      'badges': badges.toJson(),
      'url': url,
    };
  }

  ProductItem copyWith({
    int? productId,
    String? name,
    String? shortDescription,
    String? imageUrl,
    Price? price,
    Rating? rating,
    Badges? badges,
    String? url,
  }) {
    return ProductItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      badges: badges ?? this.badges,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    shortDescription,
    imageUrl,
    price,
    rating,
    badges,
    url,
  ];
}
