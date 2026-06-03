import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/ad_provider.dart';
import '../../../../data/domains/ads/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  final Map<String, dynamic> adData;
  final int placementId;
  final int? userId;

  const BannerAdWidget({
    Key? key,
    required this.adData,
    required this.placementId,
    this.userId,
  }) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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

    final int campaignId = widget.adData['campaign_id'] ?? 0;
    final int bannerId = widget.adData['banner_id'] ?? 0;
    final String? bannerUrl = widget.adData['cb_banner_url'];

    // 1. Track click & obtain the click_id
    final clickResponse = await _adService.trackClick(
      campaignId: campaignId,
      adType: 'banner',
      bannerId: bannerId,
      placementId: widget.placementId,
      userId: widget.userId,
    );

    int? clickId;
    if (clickResponse != null && clickResponse['status'] == true) {
      clickId = clickResponse['click_id'];
    }

    // 2. Set active campaign details in AdProvider to track conversion
    if (mounted) {
      context.read<AdProvider>().setActiveAd(
        campaignId: campaignId,
        clickId: clickId,
        productId: null,
      );
    }

    // 3. Action: Launch external URL or deep link
    if (bannerUrl != null && bannerUrl.isNotEmpty) {
      final uri = Uri.parse(bannerUrl);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to open featured site.')),
            );
          }
        }
      } catch (e) {
        print('BannerAdWidget launchUrl Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.adData['banner_image_url'];
    final title = widget.adData['vc_campaign_name'] ?? 'Featured Premium Brand';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.13),
              blurRadius: 18,
              spreadRadius: 0,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Ad image
              imageUrl != null
                  ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                  : _buildPlaceholder(),

              // Bottom gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.78),
                        Colors.black.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),

              // "Sponsored" badge — top left, brand purple
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9747FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.campaign_rounded,
                        color: Colors.white,
                        size: 11,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'SPONSORED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Campaign title + CTA (bottom)
              Positioned(
                bottom: 14,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Tap to discover premium collections',
                            style: TextStyle(
                              color: Color(0xCCFFFFFF),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9747FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Shop Now →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tap ripple overlay
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onAdTap(context),
                    splashColor: const Color(
                      0xFF9747FF,
                    ).withValues(alpha: 0.18),
                    highlightColor: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFFB57AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 48),
            SizedBox(height: 10),
            Text(
              'XOTIC EXCLUSIVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
