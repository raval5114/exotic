import 'package:exotic/data/models/Homepage/elements/Items/VerticalGridItem2.dart';
import 'package:exotic/data/models/Homepage/elements/configs/product_grid_vertical_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductGridVertical2 implements PageElement {
  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final String title;

  final List<ProductGridVertical2Item> products;

  ProductGridVertical2({
    required this.elementId,
    required this.elementType,
    required this.title,
    required this.products,
  });

  factory ProductGridVertical2.fromJson(Map<String, dynamic> json) {
    return ProductGridVertical2(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      products:
          (json['products'] as List<dynamic>? ?? [])
              .map((e) => ProductGridVertical2Item.fromJson(e))
              .toList(),
    );
  }

  @override
  // TODO: implement config
  ElementConfig get config => throw UnimplementedError();

  @override
  // TODO: implement items
  List<Items> get items => throw UnimplementedError();
}
