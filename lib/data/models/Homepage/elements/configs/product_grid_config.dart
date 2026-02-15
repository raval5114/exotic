import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ProductGridConfig implements ElementConfig {
  final String viewAllLink;

  ProductGridConfig({required this.viewAllLink});
  factory ProductGridConfig.fromJson(Map<String, dynamic> e) {
    return ProductGridConfig(viewAllLink: e['view_all_link']);
  }
}
