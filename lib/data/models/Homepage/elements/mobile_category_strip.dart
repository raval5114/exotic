import 'package:exotic/data/models/Homepage/elements/Items/mobile_category_grid_items.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_offer_strip_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileCategoryGridElement implements PageElement {
  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final String title;

  @override
  final MobileCategoryGridConfig config;

  @override
  final List<MobileCategoryGridItems> items;

  MobileCategoryGridElement({
    required this.elementId,
    required this.elementType,
    required this.title,
    required this.config,
    required this.items,
  });

  factory MobileCategoryGridElement.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final rawItems = data['items'];

    List<MobileCategoryGridItems> parsedItems = [];

    if (rawItems is List) {
      parsedItems =
          rawItems
              .whereType<Map<String, dynamic>>() // crash safe
              .map((e) => MobileCategoryGridItems.fromJson(e))
              .toList();
    }

    return MobileCategoryGridElement(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      config: MobileCategoryGridConfig.fromJson(data),
      items: parsedItems,
    );
  }
}
