import 'package:exotic/data/models/Homepage/elements/Items/moblie_sponsored_banner_itmes.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_promo_banner_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileSponsoredBanner implements PageElement {
  @override
  final ElementConfig config;
  @override
  final int elementId;
  @override
  final String elementType;
  @override
  final String title;
  final MobileSponsoredBannerItems item;
  MobileSponsoredBanner({
    required this.item,
    required this.config,
    required this.elementId,
    required this.elementType,
    required this.title,
  });

  factory MobileSponsoredBanner.fromJson(Map<String, dynamic> json) {
    List<dynamic> bannersList = [];
    if (json['data'] != null && json['data']['banners'] != null) {
      bannersList = json['data']['banners'];
    } else if (json['items'] != null) {
      bannersList = json['items'];
    }

    return MobileSponsoredBanner(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config:
          json['config'] != null
              ? MobilePromoBannerConfig.fromJson(json['config'])
              : MobilePromoBannerConfig(),
      item: MobileSponsoredBannerItems.fromJson(json['data']),
    );
  }

  @override
  // TODO: implement items
  List<Items> get items => throw UnimplementedError();
}
