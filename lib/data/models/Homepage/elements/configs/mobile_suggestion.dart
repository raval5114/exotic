import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileSuggestionConfig implements ElementConfig {
  final String sectionTitle;
  final String viewAllLink;

  MobileSuggestionConfig({
    required this.sectionTitle,
    required this.viewAllLink,
  });

  factory MobileSuggestionConfig.fromJson(Map<String, dynamic> json) {
    return MobileSuggestionConfig(
      sectionTitle: json['section_title'] ?? '',
      viewAllLink: json['view_all_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'section_title': sectionTitle, 'view_all_link': viewAllLink};
  }
}
