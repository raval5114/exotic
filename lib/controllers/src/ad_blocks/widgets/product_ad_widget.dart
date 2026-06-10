import 'package:exotic/data/models/Interaction/interactions.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/controllers/Products/productShellController.dart';
import 'package:exotic/data/providers/ad_provider.dart';
import '../../../../data/domains/ads/ad_service.dart';

class ProductAdWidget extends StatefulWidget {
  final Map<String, dynamic> adData;
  final int placementId;
  final int? userId;
  final String adType; // 'product_grid' or 'search'

  const ProductAdWidget({
    Key? key,
    required this.adData,
    required this.placementId,
    this.userId,
    required this.adType,
  }) : super(key: key);

  @override
  State<ProductAdWidget> createState() => _ProductAdWidgetState();
}

class _ProductAdWidgetState extends State<ProductAdWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onAdTap(BuildContext context) async {
    _animController.forward().then((_) => _animController.reverse());
    // context.read<InteractionProvider>().addInteraction(
    //   interactionType: InteractionType.adProductList,
    //   pageName: "${widget.adType}",
    // );
    final int campaignId = widget.adData['campaign_id'] ?? 0;
    final int productId = widget.adData['product_id'] ?? 0;

    // 1. Track the click on the backend
    final clickResponse = await _adService.trackClick(
      campaignId: campaignId,
      adType: widget.adType,
      productId: productId,
      placementId: widget.placementId,
      userId: widget.userId,
    );

    int? clickId;
    if (clickResponse != null && clickResponse['status'] == true) {
      clickId = clickResponse['click_id'];
    }

    // 2. Set active campaign in AdProvider to track successful checkout conversion
    if (mounted) {
      context.read<AdProvider>().setActiveAd(
        campaignId: campaignId,
        clickId: clickId,
        productId: productId,
      );
    }

    // 3. Action: Deep link or fetch product & navigate to the details shell route
    if (mounted) {
      context.read<FetchProductBloc>().add(
        FetchingSingleProductEvent(productid: productId.toString()),
      );
      context.push('/dynamicRoute', extra: () => const ProductsShell());
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.adData['product_image_url'];
    final name = widget.adData['product_name'] ?? 'Featured Product';
    final double sellingPrice =
        double.tryParse(widget.adData['selling_price'].toString()) ?? 0.0;
    final double mrp = double.tryParse(widget.adData['mrp'].toString()) ?? 0.0;
    final double discountPercent =
        mrp > sellingPrice ? ((mrp - sellingPrice) / mrp) * 100 : 0.0;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 175,
        margin: const EdgeInsets.only(right: 14, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Area
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade50,
                      width: double.infinity,
                      child:
                          imageUrl != null
                              ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Center(
                                          child: Icon(
                                            Icons.image_not_supported_rounded,
                                            color: Colors.grey,
                                            size: 28,
                                          ),
                                        ),
                              )
                              : const Center(
                                child: Icon(
                                  Icons.image_rounded,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                              ),
                    ),
                  ),

                  // Product Details Card Info
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Sponsored" indicator line with brand color
                        Row(
                          children: const [
                            Icon(
                              Icons.campaign,
                              color: Color(0xFF9747FF),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Sponsored',
                              style: TextStyle(
                                color: Color(0xFF9747FF),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'NunitoSans',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Product Title
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                            fontFamily: 'Roboto',
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Price details block
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹${sellingPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (mrp > sellingPrice)
                              Flexible(
                                child: Text(
                                  '₹${mrp.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey.shade400,
                                    fontFamily: 'Poppins',
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Promo Badge percentage off (Top-Left)
              if (discountPercent > 0)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${discountPercent.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'NunitoSans',
                      ),
                    ),
                  ),
                ),

              // Material Tap ripple splash overlay
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onAdTap(context),
                    splashColor: const Color(
                      0xFF9747FF,
                    ).withValues(alpha: 0.09),
                    highlightColor: const Color(
                      0xFF9747FF,
                    ).withValues(alpha: 0.04),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
