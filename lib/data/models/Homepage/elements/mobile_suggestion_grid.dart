import 'package:exotic/data/models/Homepage/elements/Items/ProductItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/ProductGalleryConfig.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_suggestion.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileSuggestionGrid implements PageElement {
  @override
  final MobileSuggestionConfig config;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final List<ProductItem> items;

  @override
  final String title;

  MobileSuggestionGrid({
    required this.config,
    required this.elementId,
    required this.elementType,
    required this.items,
    required this.title,
  });

  factory MobileSuggestionGrid.fromJson(Map<String, dynamic> json) {
    return MobileSuggestionGrid(
      config: MobileSuggestionConfig.fromJson(
        json['config'] as Map<String, dynamic>? ?? {},
      ),
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      items:
          (json['products'] as List<dynamic>? ?? [])
              .map((item) => ProductItem.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}
