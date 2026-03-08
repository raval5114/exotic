import 'dart:async';
import 'package:exotic/Test/HomepagesTesting/model/bannertesting.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/dotIndicator.dart';
import 'package:exotic/data/models/Homepage/elements/Items/mobile_banner_items.dart';
import 'package:exotic/utils/cachedImage.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';

class BannerCarouselWidget extends StatefulWidget {
  final BannerContent? content;
  final List<MobileBannerItems>? banners;

  const BannerCarouselWidget({super.key, this.content, this.banners});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  String? api = "https://xotic.in/UploadImages/ElementImages/";
  Timer? _timer;

  // Computed property to get the list of items to display
  List<dynamic> get _items {
    if (widget.content?.banners.isNotEmpty ?? false) {
      return widget.content!.banners;
    }
    if (widget.banners != null && widget.banners!.isNotEmpty) {
      return widget.banners!;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    // Autoplay logic:
    // 1. If content is provided, use its settings.
    // 2. If only banners are provided (mobile testing case), default to autoplay enabled with default interval.

    bool shouldAutoplay = false;
    int interval = 3000;
    int transitionTime = 800;

    if (widget.content != null) {
      shouldAutoplay = widget.content!.autoplay;
      if (widget.content!.interval > 0) interval = widget.content!.interval;
      if (widget.content!.transitionTime > 0)
        transitionTime = widget.content!.transitionTime;
    } else if (widget.banners != null && widget.banners!.isNotEmpty) {
      // Default behavior for mobile banners list if no content config provided
      shouldAutoplay = true;
    }

    if (shouldAutoplay && _items.length > 1) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: interval), (_) {
        if (!_controller.hasClients) return;

        int nextIndex = _currentIndex + 1;
        if (nextIndex >= _items.length) {
          nextIndex = 0;
        }

        _controller.animateToPage(
          nextIndex,
          duration: Duration(milliseconds: transitionTime),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void onTap(dynamic item) {
    debugPrint("Banner tapped: $item");
    // TODO: Handle navigation based on item.linkUrl or similar
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Determine height from content or default
    double height = 200; // Default height
    if (widget.content != null && widget.content!.height != 'auto') {
      try {
        height = double.parse(widget.content!.height.replaceAll('px', ''));
      } catch (_) {}
    }

    return Column(
      children: [
        SizedBox(
          height: height,
          child: Stack(
            children: [
              PageView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => onTap(item),
                    child: ClipRRect(
                      child: Builder(
                        builder: (context) {
                          if (item is MobileBannerItems) {
                            if (!item.imageBase64Url.startsWith('http')) {
                              try {
                                final bytes = base64ToBytes(
                                  item.imageBase64Url,
                                );
                                return Image.memory(
                                  bytes,
                                  height: height,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                );
                              } catch (e) {
                                debugPrint("Error decoding base64 image: $e");
                                return Container(
                                  height: height,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image),
                                );
                              }
                            } else {
                              return AppCachedImage(
                                imageUrl: item.imageBase64Url,
                                height: height,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(12),
                              );
                            }
                          } else if (item is BannerItem) {
                            String imageUrl = (api ?? "") + item.imageFile;
                            return AppCachedImage(
                              imageUrl: imageUrl,
                              height: height,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(12),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  );
                },
              ),
              // Dots Indicator
              if (items.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: DotsIndicator(
                    count: items.length,
                    currentIndex: _currentIndex,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
