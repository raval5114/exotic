import 'package:exotic/data/models/Homepage/elements/Items/mobile_3d_icon_tray.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_3d_icon_tray_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Mobile3DIconTrayElement implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final Mobile3DIconTrayConfig config;

  @override
  final List<Mobile3DIconTrayItem> items;

  Mobile3DIconTrayElement({
    required this.title,
    required this.elementId,
    required this.elementType,
    required this.config,
    required this.items,
  });

  factory Mobile3DIconTrayElement.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final rawItems = data['items'];

    List<Mobile3DIconTrayItem> parsedItems = [];

    if (rawItems is List) {
      parsedItems =
          rawItems
              .whereType<Map<String, dynamic>>() // prevents crash
              .map((e) => Mobile3DIconTrayItem.fromJson(e))
              .toList();
    }

    return Mobile3DIconTrayElement(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config: Mobile3DIconTrayConfig.fromJson(data),
      items: parsedItems,
    );
  }
}
