import 'package:exotic/data/models/Homepage/elements/Items/ProductItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/ProductGalleryConfig.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductGallery implements PageElement {
  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final String title;
  @override
  final ProductGalleryConfig config;
  @override
  final List<ProductItem> items;

  ProductGallery({
    required this.elementId,
    required this.elementType,
    required this.title,
    required this.config,
    required this.items,
  });

  factory ProductGallery.fromJson(Map<String, dynamic> json) {
    return ProductGallery(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      config: ProductGalleryConfig.fromJson(json['config'] ?? {}),
      items:
          (json['products'] as List<dynamic>? ?? [])
              .map((e) => ProductItem.fromJson(e))
              .toList(),
    );
  }
}
