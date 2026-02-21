import 'package:exotic/data/models/Homepage/elements/Items/mobile_grid_offer_items.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_grid_offer.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileGridOffersElement implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final MobileGridOffersConfig config;

  @override
  final List<MobileGridOfferItem> items;

  MobileGridOffersElement({
    required this.title,
    required this.elementId,
    required this.elementType,
    required this.config,
    required this.items,
  });

  factory MobileGridOffersElement.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final rawItems = data['items'];

    List<MobileGridOfferItem> parsedItems = [];

    if (rawItems is List) {
      parsedItems =
          rawItems.map((e) => MobileGridOfferItem.fromJson(e)).toList();
    }

    return MobileGridOffersElement(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config: MobileGridOffersConfig.fromJson(data),
      items: parsedItems,
    );
  }
}
