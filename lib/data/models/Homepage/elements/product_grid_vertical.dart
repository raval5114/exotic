import 'package:exotic/data/models/Homepage/elements/Items/VerticalGridItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/product_grid_vertical_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductGridVertical implements PageElement {
  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final String title;

  final ProductGridVerticalConfig config;
  final List<ProductGridVerticalItem> items;

  ProductGridVertical({
    required this.elementId,
    required this.elementType,
    required this.title,
    required this.config,
    required this.items,
  });

  factory ProductGridVertical.fromJson(Map<String, dynamic> json) {
    return ProductGridVertical(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      config: ProductGridVerticalConfig.fromJson(json['config'] ?? {}),
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => ProductGridVerticalItem.fromJson(e))
              .toList(),
    );
  }
}
