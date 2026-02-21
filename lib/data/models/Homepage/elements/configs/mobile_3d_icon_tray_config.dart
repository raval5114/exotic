import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Mobile3DIconTrayConfig implements ElementConfig {
  final String baseColor;
  final String labelColor;

  Mobile3DIconTrayConfig({required this.baseColor, required this.labelColor});

  factory Mobile3DIconTrayConfig.fromJson(Map<String, dynamic> json) {
    return Mobile3DIconTrayConfig(
      baseColor: json['base_color'] ?? '',
      labelColor: json['label_color'] ?? '',
    );
  }
}
