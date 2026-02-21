import 'package:exotic/data/models/Homepage/elements/Items/mobile_budget_deals_items.dart';
import 'package:exotic/data/models/Homepage/elements/configs/mobile_budget_deals_config.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileBudgetDealsElement implements PageElement {
  @override
  final String title;

  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final MobileBudgetDealsConfig config;

  @override
  final List<MobileBudgetDealItem> items;

  MobileBudgetDealsElement({
    required this.title,
    required this.elementId,
    required this.elementType,
    required this.config,
    required this.items,
  });

  factory MobileBudgetDealsElement.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final rawDeals = data['deals'];

    List<MobileBudgetDealItem> parsedDeals = [];

    if (rawDeals is List) {
      parsedDeals =
          rawDeals
              .whereType<Map<String, dynamic>>() // safe cast
              .map((e) => MobileBudgetDealItem.fromJson(e))
              .toList();
    }

    return MobileBudgetDealsElement(
      title: json['title'] ?? '',
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      config: MobileBudgetDealsConfig.fromJson(data),
      items: parsedDeals,
    );
  }
}
