import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Mobile3DIconTrayItem implements Items {
  final String img;
  final String label;
  final String url;

  Mobile3DIconTrayItem({
    required this.img,
    required this.label,
    required this.url,
  });

  factory Mobile3DIconTrayItem.fromJson(Map<String, dynamic> json) {
    return Mobile3DIconTrayItem(
      img: json['img'] ?? '',
      label: json['label'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
