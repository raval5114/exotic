import 'package:exotic/data/models/Homepage/elements/Items/mobile_charm_slider_items.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_charm_slider_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileCharmSliderElement implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final MobileCharmSliderConfig config;

  @override
  final List<MobileCharmSliderCard> items;

  MobileCharmSliderElement({
    required this.title,
    required this.elementId,
    required this.elementType,
    required this.config,
    required this.items,
  });

  factory MobileCharmSliderElement.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final rawCards = data['cards'];

    List<MobileCharmSliderCard> parsedCards = [];

    if (rawCards is List) {
      parsedCards =
          rawCards
              .whereType<Map<String, dynamic>>() // prevents cast crash
              .map((e) => MobileCharmSliderCard.fromJson(e))
              .toList();
    }

    return MobileCharmSliderElement(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config: MobileCharmSliderConfig.fromJson(data),
      items: parsedCards,
    );
  }
}
