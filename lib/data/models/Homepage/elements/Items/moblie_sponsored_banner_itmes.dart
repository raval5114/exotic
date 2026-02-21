import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileSponsoredBannerItems implements Items {
  final String sectionTitle;
  final String displayMode;
  final String fullImg;
  final String bannerHeight;
  final String logoImg;
  final String mainHeading;
  final String offerText;
  final String productImg;
  final String bgStyle;
  final String linkUrl;
  MobileSponsoredBannerItems({
    required this.sectionTitle,
    required this.displayMode,
    required this.fullImg,
    required this.bannerHeight,
    required this.logoImg,
    required this.mainHeading,
    required this.offerText,
    required this.productImg,
    required this.bgStyle,
    required this.linkUrl,
  });
  factory MobileSponsoredBannerItems.fromJson(Map<String, dynamic> json) {
    return MobileSponsoredBannerItems(
      sectionTitle: json['section_title'] ?? '',
      displayMode: json['display_mode'] ?? '',
      fullImg: json['full_img'] ?? '',
      bannerHeight: json['banner_height'] ?? '',
      logoImg: json['logo_img'] ?? '',
      mainHeading: json['main_heading'] ?? '',
      offerText: json['offer_text'] ?? '',
      productImg: json['product_img'] ?? '',
      bgStyle: json['bg_style'] ?? '',
      linkUrl: json['link_url'] ?? '',
    );
  }
}
