import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileGridOfferItem implements Items {
  final String img;
  final String label;
  final String offer;
  final String url;

  MobileGridOfferItem({
    required this.img,
    required this.label,
    required this.offer,
    required this.url,
  });

  factory MobileGridOfferItem.fromJson(Map<String, dynamic> json) {
    return MobileGridOfferItem(
      img: json['img'] ?? '',
      label: json['label'] ?? '',
      offer: json['offer'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
