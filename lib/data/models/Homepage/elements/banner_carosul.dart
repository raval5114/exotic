import 'package:exotic/data/models/Homepage/elements/Items/BannerItem.dart';
import 'package:exotic/data/models/Homepage/elements/configs/banner_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Banner implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final Bannerconfig config;

  @override
  final List<BannerItem> items;

  const Banner({
    required this.title,
    required this.elementId,
    required this.elementType,
    required this.config,
    required this.items,
  });

  factory Banner.fromJson(Map<String, dynamic> e) {
    return Banner(
      title: e['title'] ?? '',
      elementId: e['element_id'] ?? 0,
      elementType: e['element_type'] ?? '',
      config:
          e['config'] != null
              ? Bannerconfig.fromJson(e['config'])
              : Bannerconfig(
                autoplay: false,
                interval: 0,
                loop: false,
                effect: '',
                showPagination: false,
                showNavigation: false,
              ),
      items:
          (e['items'] as List<dynamic>? ?? [])
              .map((item) => BannerItem.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}
