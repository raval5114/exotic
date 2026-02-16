import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobilePromoBanner implements PageElement {
  @override
  final ElementConfig config;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final List<Items> items;

  @override
  final String title;

  MobilePromoBanner({
    required this.config,
    required this.elementId,
    required this.elementType,
    required this.items,
    required this.title,
  });
}
