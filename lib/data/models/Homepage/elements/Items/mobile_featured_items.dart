import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileFeaturedSliderCard implements Items {
  final String img;
  final String offer;
  final String title;
  final String url;

  MobileFeaturedSliderCard({
    required this.img,
    required this.offer,
    required this.title,
    required this.url,
  });

  factory MobileFeaturedSliderCard.fromJson(Map<String, dynamic> json) {
    return MobileFeaturedSliderCard(
      img: json['img'] ?? '',
      offer: json['offer'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
