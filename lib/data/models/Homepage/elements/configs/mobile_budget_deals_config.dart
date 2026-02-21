import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileBudgetDealsConfig implements ElementConfig {
  final String sectionTitle;

  MobileBudgetDealsConfig({required this.sectionTitle});

  factory MobileBudgetDealsConfig.fromJson(Map<String, dynamic> json) {
    return MobileBudgetDealsConfig(sectionTitle: json['section_title'] ?? '');
  }
}
