import 'package:exotic/Test/HomepagesTesting/model/interactions/shell/interactionShell.dart';
import 'package:exotic/data/models/product_orignal.dart';

class ExoticProduct implements InteractionShell {
  @override
  final String createdAt;

  @override
  final int interactionId;

  @override
  final String interactionType;

  @override
  final String updatedAt;
  final ProductModel product;
  ExoticProduct({
    required this.product,
    required this.createdAt,
    required this.interactionId,
    required this.interactionType,
    required this.updatedAt,
  });

  @override
  InteractionShell fromJson(Map<String, dynamic> json) {
    return ExoticProduct(
      product: ProductModel.fromJson(json['product']),
      interactionId: json['interactionId'],
      interactionType: json['interactionType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'interactionId': interactionId,
      'interactionType': interactionType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
