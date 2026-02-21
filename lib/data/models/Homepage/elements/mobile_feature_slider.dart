import 'package:exotic/data/models/Homepage/elements/Items/mobile_featured_items.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_feature_slider_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileFeaturedSliderElement implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final MobileFeaturedSliderConfig config;

  @override
  final List<MobileFeaturedSliderCard> items;

  MobileFeaturedSliderElement({
    required this.title,
    required this.elementId,
    required this.elementType,
    required this.config,
    required this.items,
  });

  factory MobileFeaturedSliderElement.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final rawCards = data['cards'];

    List<MobileFeaturedSliderCard> parsedCards = [];

    if (rawCards is List) {
      parsedCards =
          rawCards.map((e) => MobileFeaturedSliderCard.fromJson(e)).toList();
    }

    return MobileFeaturedSliderElement(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config: MobileFeaturedSliderConfig.fromJson(data),
      items: parsedCards,
    );
  }
}
