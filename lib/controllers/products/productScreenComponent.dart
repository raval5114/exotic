import 'package:exotic/controllers/Homescreen/widgets/homepageItemShowingSection.dart';
import 'package:exotic/controllers/products/shared/ProductDetailsComponent.dart';
import 'package:exotic/controllers/products/shared/productAllOffersAndCoupens.dart';
import 'package:exotic/controllers/products/shared/productAvailableOffersComponent.dart';
import 'package:exotic/controllers/products/shared/productBankOffersCompoent.dart';
import 'package:exotic/controllers/products/shared/productDeliveryAddressComponent.dart';
import 'package:exotic/controllers/products/shared/productDeliveryAndReturnPolicyComponent.dart';
import 'package:exotic/controllers/products/shared/productRatingsAndReviewsComponents.dart';
import 'package:exotic/controllers/products/shared/productSellerDetailsComponent.dart';
import 'package:exotic/controllers/products/shared/productVariantComponet.dart';
import 'package:exotic/controllers/products/shared/productsDescriptionComponent.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:exotic/data/providers/product_provider.dart';
import 'package:exotic/utils/newProductList.dart';
import 'package:exotic/controllers/src/ad_blocks/widgets/ad_block.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreenComponent extends StatefulWidget {
  const ProductScreenComponent({super.key});

  @override
  State<ProductScreenComponent> createState() => _ProductScreenComponentState();
}

class _ProductScreenComponentState extends State<ProductScreenComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final product = provider.product;

        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic Top Ad Placement
              const AdBlock(page: 'product', position: 'top', limit: 3),

              ProductsdescriptionComponent(
                productName: product.pName ?? "Name not found",
                imgages: provider.images,
                ratings: 0,
                discount: provider.discount,
                discountedPrice: provider.sellingPrice,
                initialPrice: provider.mrpPrice,
                isFreeDelivery: product.pFreeShipping == "1",
                sizeChart: products[1]["sizeChart"],
              ),

              /// ✅ VARIANTS
              if (provider.hasVariants)
                ProductVariantComponent(variants: product.variants!),

              ProductDeliveryAndReturnPolicyComponent(product: product),
              ProductAvailableOffersComponent(product: product),
              ProductAllOffersAndCouponsComponent(),
              ProductBankOffersComponent(product: product),

              ProductDeliveryAddressComponent(
                name: "Delivery Name",
                pincode: "000000",
                addressLine: "Address Not Found",
                onChange: () {},
              ),

              ProductDetailsComponent(product: product),

              // Dynamic Middle Ad Placement
              const AdBlock(page: 'product', position: 'middle', limit: 3),

              Productsellerdetailscomponent(
                sellerName: "Vendor Name",
                isTrusted: true,
                ratings: 4.3,
              ),

              Consumer<InteractionProvider>(
                builder: (context, interactionProvider, _) {
                  // Map InteractionProductModel → the shape HomePageItemShowingSection expects.
                  final recentItems =
                      interactionProvider.interactions.reversed
                          .map(
                            (entry) => <String, dynamic>{
                              'productName': entry.product.pName ?? '',
                              'imgages': entry.product.pMainImage ?? '',
                              'discountedPrice':
                                  double.tryParse(
                                    entry.product.pSellingPrice ?? '0',
                                  ) ??
                                  0.0,
                              'initialPrice':
                                  double.tryParse(
                                    entry.product.pMrpPrice ?? '0',
                                  ) ??
                                  0.0,
                              'discount':
                                  int.tryParse(
                                    entry.product.pDiscount ?? '0',
                                  ) ??
                                  0,
                              'isFreeDelivery':
                                  entry.product.pFreeShipping == '1',
                              'ratings': 0,
                              'pId': entry.product.pId,
                            },
                          )
                          .toList();

                  if (recentItems.isEmpty) return const SizedBox.shrink();

                  return Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 2),
                    child: HomePageItemShowingSection(
                      title: 'Recently Viewed',
                      itemList: recentItems,
                      frontItemLength: recentItems.length.clamp(1, 10),
                      rows: 1,
                    ),
                  );
                },
              ),

              Productratingsandreviewscomponents(
                productId: int.parse(product.pId!),
              ),

              // Dynamic Bottom Ad Placement
              const AdBlock(page: 'product', position: 'bottom', limit: 3),
              // Dynamic Bottom Ad Placement
              const AdBlock(page: 'product', position: 'bottom', limit: 3),
              // Dynamic Bottom Ad Placement
              const AdBlock(page: 'product', position: 'bottom', limit: 3),
              // Dynamic Bottom Ad Placement
              const AdBlock(page: 'product', position: 'bottom', limit: 3),

              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }
}
