import 'package:exotic/data/models/Homepage/elements/Items/mobile_banner_items.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_promo_banner_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobilePromoBanner implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final MobilePromoBannerConfig config;

  @override
  final List<MobileBannerItems> items;

  MobilePromoBanner({
    required this.config,
    required this.elementId,
    required this.elementType,
    required this.items,
    required this.title,
  });

  factory MobilePromoBanner.fromJson(Map<String, dynamic> json) {
    List<dynamic> bannersList = [];
    if (json['data'] != null && json['data']['banners'] != null) {
      bannersList = json['data']['banners'];
    } else if (json['items'] != null) {
      bannersList = json['items'];
    }

    return MobilePromoBanner(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config:
          json['config'] != null
              ? MobilePromoBannerConfig.fromJson(json['config'])
              : MobilePromoBannerConfig(),
      items:
          bannersList
              .map((e) => MobileBannerItems.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
