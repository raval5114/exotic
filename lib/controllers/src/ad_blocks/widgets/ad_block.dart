import 'package:exotic/data/models/Interaction/interactions.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/providers/ad_provider.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/controllers/Products/productShellController.dart';
import '../../../../data/domains/ads/ad_service.dart';
import 'banner_ad_widget.dart';
import 'product_ad_widget.dart';

class AdBlock extends StatefulWidget {
  final String page;
  final String position;
  final int? categoryId;
  final String? keyword;
  final int limit;

  const AdBlock({
    Key? key,
    required this.page,
    required this.position,
    this.categoryId,
    this.keyword,
    this.limit = 3,
  }) : super(key: key);

  @override
  _AdBlockState createState() => _AdBlockState();
}

class _AdBlockState extends State<AdBlock> {
  bool _isLoading = true;
  Map<String, dynamic>? _placement;
  List<dynamic> _ads = [];
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  Future<void> _loadAds() async {
    if (!mounted) return;

    final userProvider = context.read<UserProvider>();
    final userId = userProvider.user?.customerId;

    final result = await _adService.fetchAdPlacement(
      page: widget.page,
      position: widget.position,
      userId: userId != 0 ? userId : null,
      categoryId: widget.categoryId,
      keyword: widget.keyword,
      limit: widget.limit,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result != null) {
          _placement = result['placement'];
          _ads = result['ads'] ?? [];
        }
      });
    }
    if (widget.page == "product") {
      context.read<InteractionProvider>().addInteraction(
        interactionType: InteractionType.adProductList,
        pageName: "${_placement!["vc_name"]}",
      );
    } else {
      context.read<InteractionProvider>().addInteraction(
        interactionType: InteractionType.adBanner,
        pageName: "${_placement!["vc_name"]}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── Loading shimmer ────────────────────────────────────────────────────
    if (_isLoading) {
      return _AdShimmer(
        isBanner:
            (widget.page != 'product' && widget.page != 'product-grid') ||
            widget.position != 'top',
        isTopSlider: widget.page == 'product' && widget.position == 'top',
        isProductGrid: widget.page == 'product-grid',
      );
    }

    if (_ads.isEmpty || _placement == null) {
      return const SizedBox.shrink();
    }

    final adType = _placement!['ad_type'];
    final placementId =
        _placement!['id'] is String
            ? int.tryParse(_placement!['id']) ?? 0
            : (_placement!['id'] as int? ?? 0);

    final userProvider = context.read<UserProvider>();
    final userId =
        userProvider.user?.customerId != 0
            ? userProvider.user?.customerId
            : null;

    // ── Product-page top → compact horizontal slider ────────────────────
    if (widget.page == 'product' && widget.position == 'top') {
      return ProductTopAdSlider(
        ads: _ads,
        placementId: placementId,
        userId: userId,
      );
    }

    // ── Banner (promote_brand) ─────────────────────────────────────────
    if (adType == 'promote_brand') {
      // context.read<InteractionProvider>().addInteraction(
      //   interactionType: InteractionType.adBanner,
      //   pageName: "${_placement!['vc_name']}",
      // );
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:
              _ads.map((ad) {
                return BannerAdWidget(
                  adData: ad,
                  placementId: placementId,
                  userId: userId,
                );
              }).toList(),
        ),
      );
    }

    // ── Product carousel (promote_product / display_product) ────────────
    if (adType == 'promote_product' || adType == 'display_product') {
      // context.read<InteractionProvider>().addInteraction(
      //   interactionType: InteractionType.adProductList,
      //   pageName: _placement!['vc_name'],
      // );
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3.5,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9747FF),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _placement!['vc_name'] ?? 'Premium Selections',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EBFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Sponsored',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF7B2FF7),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Horizontal card list ────────────────────────────────────
            SizedBox(
              height: 255,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 4),
                itemCount: _ads.length,
                itemBuilder: (context, index) {
                  return ProductAdWidget(
                    adData: _ads[index],
                    placementId: placementId,
                    userId: userId,
                    adType: widget.page == 'search' ? 'search' : 'product_grid',
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // ── Product-grid page → inline 2-column sponsored grid ────────────────
    if (widget.page == 'product-grid') {
      return _ProductGridAdBlock(
        ads: _ads,
        placementId: placementId,
        userId: userId,
        vcName: _placement!['vc_name'] ?? 'Sponsored',
      );
    }

    return const SizedBox.shrink();
  }
}

// ── Shimmer placeholder ──────────────────────────────────────────────────────
// ── ProductGridAdBlock ────────────────────────────────────────────────────────
/// Renders a 2-column grid of sponsored product cards for the `product-grid` page.
class _ProductGridAdBlock extends StatefulWidget {
  final List<dynamic> ads;
  final int placementId;
  final int? userId;
  final String vcName;

  const _ProductGridAdBlock({
    required this.ads,
    required this.placementId,
    required this.vcName,
    this.userId,
  });

  @override
  State<_ProductGridAdBlock> createState() => _ProductGridAdBlockState();
}

class _ProductGridAdBlockState extends State<_ProductGridAdBlock> {
  final AdService _adService = AdService();

  void _onCardTap(Map<String, dynamic> adData) async {
    final int campaignId = adData['campaign_id'] ?? 0;
    final int productId = adData['product_id'] ?? 0;

    final clickResponse = await _adService.trackClick(
      campaignId: campaignId,
      adType: 'product_grid',
      productId: productId,
      placementId: widget.placementId,
      userId: widget.userId,
    );

    int? clickId;
    if (clickResponse != null && clickResponse['status'] == true) {
      clickId = clickResponse['click_id'];
    }

    if (mounted) {
      context.read<AdProvider>().setActiveAd(
        campaignId: campaignId,
        clickId: clickId,
        productId: productId,
      );
      context.read<FetchProductBloc>().add(
        FetchingSingleProductEvent(productid: productId.toString()),
      );
      context.push('/dynamicRoute', extra: () => const ProductsShell());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ads.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9747FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.vcName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EBFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Sponsored',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF7B2FF7),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── 2-column grid ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.ads.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final ad = widget.ads[index];
                return _ProductGridAdCard(
                  adData: ad,
                  onTap: () => _onCardTap(ad),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Single card inside the product-grid ad block.
class _ProductGridAdCard extends StatefulWidget {
  final Map<String, dynamic> adData;
  final VoidCallback onTap;

  const _ProductGridAdCard({required this.adData, required this.onTap});

  @override
  State<_ProductGridAdCard> createState() => _ProductGridAdCardState();
}

class _ProductGridAdCardState extends State<_ProductGridAdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.adData['product_image_url'];
    final name = widget.adData['product_name'] ?? 'Sponsored Product';
    final double selling =
        double.tryParse(widget.adData['selling_price'].toString()) ?? 0.0;
    final double mrp = double.tryParse(widget.adData['mrp'].toString()) ?? 0.0;
    final int discPct =
        mrp > selling ? (((mrp - selling) / mrp) * 100).round() : 0;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEDE4FF), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9747FF).withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Image ─────────────────────────────────────────
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF8F5FF),
                        width: double.infinity,
                        child:
                            imageUrl != null
                                ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => _imgPlaceholder(),
                                )
                                : _imgPlaceholder(),
                      ),
                    ),

                    // ── Info ──────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Sponsored" micro-label
                          const Row(
                            children: [
                              Icon(
                                Icons.campaign_rounded,
                                color: Color(0xFF9747FF),
                                size: 12,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Sponsored',
                                style: TextStyle(
                                  color: Color(0xFF9747FF),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Product name
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                              fontFamily: 'Roboto',
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Price row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '₹${selling.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111111),
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              if (mrp > selling) ...[
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    '₹${mrp.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.grey.shade400,
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Roboto',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Discount badge
                if (discPct > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '$discPct% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imgPlaceholder() {
    return const Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Color(0xFFD3BBFF),
        size: 32,
      ),
    );
  }
}

// ── Shimmer placeholder ──────────────────────────────────────────────────────
class _AdShimmer extends StatefulWidget {
  final bool isBanner;
  final bool isTopSlider;
  final bool isProductGrid;
  const _AdShimmer({
    required this.isBanner,
    required this.isTopSlider,
    this.isProductGrid = false,
  });

  @override
  State<_AdShimmer> createState() => _AdShimmerState();
}

class _AdShimmerState extends State<_AdShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = Tween<double>(
      begin: -1.5,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _shimmerBox(double w, double h, {double radius = 8}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF8F8F8),
                Color(0xFFEEEEEE),
              ],
              stops: [
                (_anim.value - 0.5).clamp(0.0, 1.0),
                _anim.value.clamp(0.0, 1.0),
                (_anim.value + 0.5).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTopSlider) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: _shimmerBox(double.infinity, 62, radius: 12),
      );
    }

    if (widget.isBanner) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: _shimmerBox(double.infinity, 180, radius: 20),
      );
    }

    // Product-grid shimmer — 2-column grid placeholder
    if (widget.isProductGrid) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _shimmerBox(160, 18, radius: 6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemBuilder:
                    (_, __) => _shimmerBox(
                      double.infinity,
                      double.infinity,
                      radius: 16,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    // Product carousel shimmer
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _shimmerBox(160, 18, radius: 6),
          ),
          SizedBox(
            height: 255,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 16),
              itemCount: 3,
              itemBuilder:
                  (_, __) => Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: _shimmerBox(155, 255, radius: 18),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── ProductTopAdSlider ───────────────────────────────────────────────────────
class ProductTopAdSlider extends StatefulWidget {
  final List<dynamic> ads;
  final int placementId;
  final int? userId;

  const ProductTopAdSlider({
    Key? key,
    required this.ads,
    required this.placementId,
    this.userId,
  }) : super(key: key);

  @override
  State<ProductTopAdSlider> createState() => _ProductTopAdSliderState();
}

class _ProductTopAdSliderState extends State<ProductTopAdSlider> {
  late final PageController _pageController;
  int _currentPage = 0;
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAdTap(Map<String, dynamic> adData) async {
    final int campaignId = adData['campaign_id'] ?? 0;
    final int productId = adData['product_id'] ?? 0;

    final clickResponse = await _adService.trackClick(
      campaignId: campaignId,
      adType: 'product_grid',
      productId: productId,
      placementId: widget.placementId,
      userId: widget.userId,
    );

    int? clickId;
    if (clickResponse != null && clickResponse['status'] == true) {
      clickId = clickResponse['click_id'];
    }

    if (mounted) {
      context.read<AdProvider>().setActiveAd(
        campaignId: campaignId,
        clickId: clickId,
        productId: productId,
      );
      context.read<FetchProductBloc>().add(
        FetchingSingleProductEvent(productid: productId.toString()),
      );
      context.push('/dynamicRoute', extra: () => const ProductsShell());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ads.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Page view ────────────────────────────────────────────────
          SizedBox(
            height: 62,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.ads.length,
              onPageChanged: (p) => setState(() => _currentPage = p),
              itemBuilder: (context, index) {
                final ad = widget.ads[index];
                final imageUrl = ad['product_image_url'];
                final name = ad['product_name'] ?? 'Featured Product';
                final double selling =
                    double.tryParse(ad['selling_price'].toString()) ?? 0.0;
                final double mrp = double.tryParse(ad['mrp'].toString()) ?? 0.0;
                final int discPct =
                    mrp > selling ? (((mrp - selling) / mrp) * 100).round() : 0;

                return GestureDetector(
                  onTap: () => _onAdTap(ad),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFE8DAFF),
                        width: 0.9,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              imageUrl != null
                                  ? Image.network(
                                    imageUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => _thumbPlaceholder(),
                                  )
                                  : _thumbPlaceholder(),
                        ),
                        const SizedBox(width: 10),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F2937),
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // "AD" pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE4FF),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'AD',
                                      style: TextStyle(
                                        color: Color(0xFF7B2FF7),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text(
                                    '₹${selling.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF111111),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  if (mrp > selling) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      '₹${mrp.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: Colors.grey.shade400,
                                        decoration: TextDecoration.lineThrough,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ],
                                  if (discPct > 0) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      '$discPct% off',
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        color: Color(0xFF1B8A5A),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Chevron
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Color(0xFF9747FF),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Dot indicators (only if >1 ad) ───────────────────────────
          if (widget.ads.length > 1) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.ads.length, (i) {
                final bool active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: active ? 14 : 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                        active
                            ? const Color(0xFF9747FF)
                            : const Color(0xFFD9C9FF),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8DAFF), Color(0xFFF3EBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        size: 22,
        color: Color(0xFF9747FF),
      ),
    );
  }
}
