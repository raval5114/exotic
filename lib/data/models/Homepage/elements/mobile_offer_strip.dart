// ============================================================
// MOBILE OFFER STRIP IMPLEMENTATION
// ============================================================

import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileOfferStripElement implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final MobileOfferStripConfig config;

  @override
  final List<MobileOfferItem> items;

  MobileOfferStripElement({
    required this.title,
    required this.elementId,
    required this.elementType,
    required this.config,
    required this.items,
  });

  factory MobileOfferStripElement.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final rawItems = data['items'];

    List<MobileOfferItem> parsedItems = [];

    if (rawItems is Map<String, dynamic>) {
      parsedItems =
          rawItems.values.map((e) => MobileOfferItem.fromJson(e)).toList();
    } else if (rawItems is List) {
      parsedItems = rawItems.map((e) => MobileOfferItem.fromJson(e)).toList();
    }

    return MobileOfferStripElement(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config: MobileOfferStripConfig.fromJson(data),
      items: parsedItems,
    );
  }
}
// ----------------------
// CONFIG MODEL
// ----------------------

class MobileOfferStripConfig implements ElementConfig {
  final String title;
  final String bgColor;

  MobileOfferStripConfig({required this.title, required this.bgColor});

  factory MobileOfferStripConfig.fromJson(Map<String, dynamic> json) {
    return MobileOfferStripConfig(
      title: json['title'] ?? '',
      bgColor: json['bg_color'] ?? '',
    );
  }
}
// ----------------------
// ITEM MODEL
// ----------------------

class MobileOfferItem implements Items {
  final String image;
  final String logo;
  final String badge;
  final String offer;
  final String caption;
  final String link;

  MobileOfferItem({
    required this.image,
    required this.logo,
    required this.badge,
    required this.offer,
    required this.caption,
    required this.link,
  });

  factory MobileOfferItem.fromJson(Map<String, dynamic> json) {
    return MobileOfferItem(
      image: json['image'] ?? '',
      logo: json['logo'] ?? '',
      badge: json['badge'] ?? '',
      offer: json['offer'] ?? '',
      caption: json['caption'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
