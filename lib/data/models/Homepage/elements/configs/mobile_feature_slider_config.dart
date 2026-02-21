import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileFeaturedSliderConfig implements ElementConfig {
  final String sectionTitle;

  MobileFeaturedSliderConfig({required this.sectionTitle});

  factory MobileFeaturedSliderConfig.fromJson(Map<String, dynamic> json) {
    return MobileFeaturedSliderConfig(
      sectionTitle: json['section_title'] ?? '',
    );
  }
}
