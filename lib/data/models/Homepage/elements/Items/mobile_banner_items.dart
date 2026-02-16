import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileBannerItems implements Items {
  final String imageBase64Url;
  final String? url;

  MobileBannerItems({required this.imageBase64Url, required this.url});
  factory MobileBannerItems.fromJson(Map<String, dynamic> e) {
    return MobileBannerItems(imageBase64Url: e['image'], url: e['url']);
  }
}
