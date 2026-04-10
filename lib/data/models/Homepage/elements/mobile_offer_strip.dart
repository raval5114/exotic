import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileOfferStripConfig implements ElementConfig {}

class MobileOfferStrip implements PageElement {
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

  MobileOfferStrip({
    required this.elementId,
    required this.elementType,
    required this.title,
    this.data,
    required this.config,
    required this.items,
  });

  factory MobileOfferStrip.fromJson(Map<String, dynamic> json) {
    return MobileOfferStrip(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      data: json['data'],
      config: MobileOfferStripConfig(),
      items: [],
    );
  }
}
