import 'package:exotic/data/models/Interaction/abtract/interaction_shell.dart';
import 'package:exotic/data/models/product_orignal.dart';

export 'package:exotic/data/models/Interaction/abtract/interaction_shell.dart';

// ─────────────────────────────────────────────────────────────────────────────
// InteractionPageModel — records a page navigation event
// ─────────────────────────────────────────────────────────────────────────────

class InteractionPageModel implements InteractionsShell {
  @override
  final InteractionType interactionType;

  @override
  final String lastViewedAt;

  final String pageName;

  InteractionPageModel({
    required this.interactionType,
    required this.pageName,
    String? lastViewedAt,
  }) : lastViewedAt = lastViewedAt ?? DateTime.now().toIso8601String();

  @override
  Map<String, dynamic> toJson() {
    return {
      'kind': 'page',
      'interactionType': interactionType.name,
      'pageName': pageName,
      'lastViewedAt': lastViewedAt,
    };
  }

  factory InteractionPageModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['interactionType'] as String? ?? '';
    final typeName = rawType.contains('.') ? rawType.split('.').last : rawType;
    final type = InteractionType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => InteractionType.homeScreen,
    );
    return InteractionPageModel(
      interactionType: type,
      pageName: json['pageName'] as String? ?? '',
      lastViewedAt: json['lastViewedAt'] as String?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// InteractionProductModel — records a product view event
// ─────────────────────────────────────────────────────────────────────────────

class InteractionProductModel implements InteractionsShell {
  @override
  final InteractionType interactionType;

  @override
  final String lastViewedAt;

  final ProductModel product;

  /// Unique ID for this interaction entry (epoch ms as string).
  final String interactionId;

  InteractionProductModel({
    required this.product,
    required this.interactionType,
    required this.interactionId,
    String? lastViewedAt,
  }) : lastViewedAt = lastViewedAt ?? DateTime.now().toIso8601String();

  @override
  Map<String, dynamic> toJson() {
    return {
      'kind': 'product',
      'product': product.toJson(),
      'lastViewedAt': lastViewedAt,
      'interactionId': interactionId,
      'interactionType': interactionType.name,
    };
  }

  factory InteractionProductModel.fromJson(Map<String, dynamic> json) {
    final productData = json['product'];
    final ProductModel parsedProduct;
    if (productData is Map<String, dynamic>) {
      parsedProduct = ProductModel.fromJson(productData);
    } else {
      // Legacy / compact storage: only pId was stored.
      parsedProduct = ProductModel(pId: productData?.toString());
    }

    final rawType = json['interactionType'] as String? ?? '';
    final typeName = rawType.contains('.') ? rawType.split('.').last : rawType;
    final interactionType = InteractionType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => InteractionType.productView,
    );

    return InteractionProductModel(
      product: parsedProduct,
      lastViewedAt: json['lastViewedAt'] as String?,
      interactionId: json['interactionId'] as String? ?? '',
      interactionType: interactionType,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RecentlyAdded — envelope used for SharedPreferences persistence
// ─────────────────────────────────────────────────────────────────────────────

class RecentlyAdded {
  final List<InteractionProductModel> products;
  final String lastViewedAt;

  RecentlyAdded({required this.products, required this.lastViewedAt});

  Map<String, dynamic> toJson() {
    return {
      'product': products.map((e) => e.toJson()).toList(),
      'lastViewedAt': lastViewedAt,
    };
  }

  factory RecentlyAdded.fromJson(Map<String, dynamic> json) {
    return RecentlyAdded(
      products:
          (json['product'] as List<dynamic>?)
              ?.map(
                (e) =>
                    InteractionProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      lastViewedAt:
          json['lastViewedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}
