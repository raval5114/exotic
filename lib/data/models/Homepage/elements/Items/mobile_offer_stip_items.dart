import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileOfferStripItem implements Items {
  final String image;
  final String logo;
  final String badge;
  final String offer;
  final String caption;
  final String link;

  MobileOfferStripItem({
    required this.image,
    required this.logo,
    required this.badge,
    required this.offer,
    required this.caption,
    required this.link,
  });

  factory MobileOfferStripItem.fromJson(Map<String, dynamic> json) {
    return MobileOfferStripItem(
      image: json['image']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
      badge: json['badge']?.toString() ?? '',
      offer: json['offer']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'logo': logo,
      'badge': badge,
      'offer': offer,
      'caption': caption,
      'link': link,
    };
  }
}
