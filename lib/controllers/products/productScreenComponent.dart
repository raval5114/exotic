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
import 'package:exotic/controllers/products/src/productReview.dart';
import 'package:exotic/data/providers/product_provider.dart';
import 'package:exotic/utils/newProductList.dart';
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

              Productsellerdetailscomponent(
                sellerName: "Vendor Name",
                isTrusted: true,
                ratings: 4.3,
              ),

              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 2),
                child: HomePageItemShowingSection(
                  title: "Recently Added",
                  itemList: products,
                  frontItemLength: 4,
                  rows: 1,
                ),
              ),

              Productratingsandreviewscomponents(
                reviews:
                    (products[1]["reviews"] as List)
                        .map(
                          (e) => ProductReview(
                            rating: e["rating"],
                            reviewText: e["reviewText"],
                            sizeInfo: e["sizeInfo"],
                            qualityText: e["qualityText"],
                          ),
                        )
                        .toList(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
