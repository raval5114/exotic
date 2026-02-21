import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileCharmSliderConfig implements ElementConfig {
  final String sectionTitle;
  final String sectionIcon;
  final String charm;
  final String sectionTitleColor;
  final String cardTextColor;
  final String bgColor;
  final String stackedBgColor;
  final String borderColor;

  MobileCharmSliderConfig({
    required this.sectionTitle,
    required this.sectionIcon,
    required this.charm,
    required this.sectionTitleColor,
    required this.cardTextColor,
    required this.bgColor,
    required this.stackedBgColor,
    required this.borderColor,
  });

  factory MobileCharmSliderConfig.fromJson(Map<String, dynamic> json) {
    return MobileCharmSliderConfig(
      sectionTitle: json['section_title'] ?? '',
      sectionIcon: json['section_icon'] ?? '',
      charm: json['charm'] ?? '',
      sectionTitleColor: json['section_title_color'] ?? '',
      cardTextColor: json['card_text_color'] ?? '',
      bgColor: json['bg_color'] ?? '',
      stackedBgColor: json['stacked_bg_color'] ?? '',
      borderColor: json['border_color'] ?? '',
    );
  }
}
