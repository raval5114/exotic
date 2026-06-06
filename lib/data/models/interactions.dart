import 'package:exotic/data/models/product_orignal.dart';

enum InteractionType {
  ProductView,
  Cart,
  Wishlist,
  Order,
  Banner,
  AdBanner,
  CategoryView,
}

class RecentlyAdded {
  final List<InteractionProductModel> product;
  final String lastViewedAt;

  RecentlyAdded({required this.product, required this.lastViewedAt});

  Map<String, dynamic> toJson() {
    return {
      'product': product.map((e) => e.toJson()).toList(),
      'lastViewedAt': lastViewedAt,
    };
  }

  factory RecentlyAdded.fromJson(Map<String, dynamic> json) {
    return RecentlyAdded(
      product:
          (json['product'] as List<dynamic>?)
              ?.map(
                (e) =>
                    InteractionProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      lastViewedAt: json['lastViewedAt'] as String,
    );
  }
}

class InteractionProductModel {
  final ProductModel product;
  final String lastViewedAt;
  final int interactionId;
  final InteractionType interactionType;
  const InteractionProductModel({
    required this.product,
    required this.lastViewedAt,
    required this.interactionId,
    required this.interactionType,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'p_id': product.pId,
        'p_name': product.pName,
        'p_url': product.pUrl,
        'p_main_image': product.pMainImage,
        'p_selling_price': product.pSellingPrice,
        'p_unit_price': product.pUnitPrice,
        'p_discount': product.pDiscount,
        'p_discount_type': product.pDiscountType,
        'p_mrp_price': product.pMrpPrice,
        'p_qty': product.pQty,
        'p_status': product.pStatus,
        'p_vendor_id': product.pVendorId,
        'p_brand_id': product.pBrandId,
        'p_short_desc': product.pShortDesc,
        'p_gallery_images': product.pGalleryImages,
        'p_first_c_id': product.pFirstCId,
        'p_second_c_id': product.pSecondCId,
        'p_third_c_id': product.pThirdCId,
        'p_type': product.pType,
        'p_sku': product.pSku,
        'p_tags': product.pTags,
        'variants': [],
      },
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
      // Legacy: only pId was stored — reconstruct a minimal stub.
      parsedProduct = ProductModel(pId: productData?.toString());
    }

    // Parse interactionType by name, stripping legacy "InteractionType." prefix.
    final rawType = json['interactionType'] as String? ?? '';
    final typeName = rawType.contains('.')
        ? rawType.split('.').last
        : rawType;
    final interactionType = InteractionType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => InteractionType.ProductView,
    );

    return InteractionProductModel(
      product: parsedProduct,
      lastViewedAt: json['lastViewedAt'] as String,
      interactionId: json['interactionId'] as int,
      interactionType: interactionType,
    );
  }
}
