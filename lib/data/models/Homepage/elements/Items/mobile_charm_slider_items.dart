import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileCharmSliderCard implements Items {
  final String img;
  final String title;
  final String price;
  final String url;

  MobileCharmSliderCard({
    required this.img,
    required this.title,
    required this.price,
    required this.url,
  });

  factory MobileCharmSliderCard.fromJson(Map<String, dynamic> json) {
    return MobileCharmSliderCard(
      img: json['img'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
