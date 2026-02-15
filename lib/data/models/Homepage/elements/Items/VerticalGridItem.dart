import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductGridVerticalItem implements Items {
  final String title;
  final String subtitle;
  final String linkUrl;
  final String imageUrl;
  final List<String> additionalImages;
  final String price;
  final String originalPrice;
  final String discount;
  final String tag;
  final int rating;
  final String notes;

  ProductGridVerticalItem({
    required this.title,
    required this.subtitle,
    required this.linkUrl,
    required this.imageUrl,
    required this.additionalImages,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.tag,
    required this.rating,
    required this.notes,
  });

  factory ProductGridVerticalItem.fromJson(Map<String, dynamic> json) {
    return ProductGridVerticalItem(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      linkUrl: json['link_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      additionalImages:
          (json['additional_images'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      price: json['price'] ?? '',
      originalPrice: json['original_price'] ?? '',
      discount: json['discount'] ?? '',
      tag: json['tag'] ?? '',
      rating: json['rating'] ?? 0,
      notes: json['notes'] ?? '',
    );
  }
}
