import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileCategoryGridItems implements Items {
  final String img;
  final String title;
  final String url;
  MobileCategoryGridItems({
    required this.img,
    required this.title,
    required this.url,
  });
  factory MobileCategoryGridItems.fromJson(Map<String, dynamic> json) {
    return MobileCategoryGridItems(
      img: json['img'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
