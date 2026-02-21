import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileGridOffersConfig implements ElementConfig {
  final String title;
  final String bgColor;

  MobileGridOffersConfig({required this.title, required this.bgColor});

  factory MobileGridOffersConfig.fromJson(Map<String, dynamic> json) {
    return MobileGridOffersConfig(
      title: json['title'] ?? '',
      bgColor: json['bg_color'] ?? '',
    );
  }
}
