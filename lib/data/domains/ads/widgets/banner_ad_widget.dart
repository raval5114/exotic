import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/ad_provider.dart';
import '../ad_service.dart';

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

class _BannerAdWidgetState extends State<BannerAdWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

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
    final clickResponse = await AdService.trackClick(
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
              color: Colors.black.withOpacity(0.12),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // High resolution ad image
              imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 155,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),

              // Vibrant double gradient overlay for ultra sleek visuals
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.75),
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Glassmorphic "Sponsored" badge with a shimmering design
              Positioned(
                top: 14,
                left: 14,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.black.withOpacity(0.55),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star, color: Color(0xFFFFD700), size: 13),
                        SizedBox(width: 5),
                        Text(
                          'SPONSORED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            fontFamily: 'NunitoSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Campaign Title & Description (Bottom-Left)
              Positioned(
                bottom: 14,
                left: 16,
                right: 16,
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
                        fontSize: 17.5,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap to discover premium collections',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),

              // Tap Animation Overlay
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onAdTap(context),
                    splashColor: const Color(0xFF9747FF).withOpacity(0.18),
                    highlightColor: Colors.white.withOpacity(0.08),
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
      height: 155,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9747FF), Color(0xFFB57AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 44),
            SizedBox(height: 8),
            Text(
              'XOTIC EXCLUSIVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
