import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileCategoryGridConfig implements ElementConfig {}

class MobileCategoryGrid implements PageElement {
  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final String title;

  final dynamic data;

  @override
  final ElementConfig config;

  @override
  final List<Items> items;

  MobileCategoryGrid({
    required this.elementId,
    required this.elementType,
    required this.title,
    this.data,
    required this.config,
    required this.items,
  });

  factory MobileCategoryGrid.fromJson(Map<String, dynamic> json) {
    return MobileCategoryGrid(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      data: json['data'],
      config: MobileCategoryGridConfig(),
      items: [],
    );
  }
}
