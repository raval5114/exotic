import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class BannerItem implements Items {
  final String title;
  final String subtitle;
  final String linkUrl;
  final String imageUrl;
  final String type;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.linkUrl,
    required this.imageUrl,
    required this.type,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      linkUrl: json['link_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'link_url': linkUrl,
      'image_url': imageUrl,
      'type': type,
    };
  }
}
