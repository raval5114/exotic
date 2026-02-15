import 'package:exotic/data/models/Homepage/elements/Items/GridItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/product_grid_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductGrid implements PageElement {
  @override
  final String title;
  @override
  final ProductGridConfig config;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final List<Griditem> items;

  ProductGrid({
    required this.title,
    required this.config,
    required this.elementId,
    required this.elementType,
    required this.items,
  });
  factory ProductGrid.fromJson(Map<String, dynamic> e) {
    return ProductGrid(
      title: e['title'] ?? '',
      config:
          e['config'] != null
              ? ProductGridConfig.fromJson(e['config'])
              : ProductGridConfig(viewAllLink: ''),
      elementId: e['element_id'] ?? 0,
      elementType: e['element_type'] ?? '',
      items:
          (e['items'] as List<dynamic>? ?? [])
              .map((item) => Griditem.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}
