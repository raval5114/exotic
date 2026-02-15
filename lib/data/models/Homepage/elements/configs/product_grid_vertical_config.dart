import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductGridVerticalConfig implements ElementConfig {
  final String viewAllLink;
  final String verticalLayout;

  ProductGridVerticalConfig({
    required this.viewAllLink,
    required this.verticalLayout,
  });

  factory ProductGridVerticalConfig.fromJson(Map<String, dynamic> json) {
    return ProductGridVerticalConfig(
      viewAllLink: json['view_all_link'] ?? '',
      verticalLayout: json['vertical_layout'] ?? 'default',
    );
  }
}
