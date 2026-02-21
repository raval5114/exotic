import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class MobileBudgetDealItem implements Items {
  final String img;
  final String label;
  final String price;
  final String url;

  MobileBudgetDealItem({
    required this.img,
    required this.label,
    required this.price,
    required this.url,
  });

  factory MobileBudgetDealItem.fromJson(Map<String, dynamic> json) {
    return MobileBudgetDealItem(
      img: json['img'] ?? '',
      label: json['label'] ?? '',
      price: json['price'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
