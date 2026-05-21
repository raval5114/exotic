import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import '../ad_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  Future<void> _loadAds() async {
    if (!mounted) return;

    // Get current logged-in user id automatically
    final userProvider = context.read<UserProvider>();
    final userId = userProvider.user?.customerId;

    final result = await AdService.fetchAdPlacement(
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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF9747FF),
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (_ads.isEmpty || _placement == null) {
      // Return empty spacer if there are no ads available for this block placement
      return const SizedBox.shrink();
    }

    final adType = _placement!['ad_type'];
    final placementId = _placement!['id'] is String
        ? int.tryParse(_placement!['id']) ?? 0
        : (_placement!['id'] as int? ?? 0);

    // Retrieve userId for ad widget context
    final userProvider = context.read<UserProvider>();
    final userId = userProvider.user?.customerId != 0 ? userProvider.user?.customerId : null;

    if (adType == 'promote_brand') {
      // Banner Placements
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: _ads.map((ad) {
            return BannerAdWidget(
              adData: ad,
              placementId: placementId,
              userId: userId,
            );
          }).toList(),
        ),
      );
    } else if (adType == 'promote_product' || adType == 'display_product') {
      // Product Grid Placements
      return Container(
        height: 295,
        margin: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Elegant placement title if available
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _placement!['vc_name'] ?? 'Premium Selections',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sponsored',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NunitoSans',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
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

    return const SizedBox.shrink();
  }
}
