import 'dart:async';
import 'package:exotic/Test/HomepagesTesting/model/bannertesting.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/src/dotIndicator.dart';
import 'package:exotic/data/models/Homepage/elements/Items/mobile_banner_items.dart';
import 'package:exotic/utils/cachedImage.dart';
import 'package:exotic/utils/image_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerCarouselWidget extends StatefulWidget {
  final String? title;
  final BannerContent? content;
  final List<MobileBannerItems>? banners;
  final String? tabName;
  const BannerCarouselWidget({
    super.key,
    this.title,
    this.content,
    this.banners,
    this.tabName,
  });

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
    bool shouldAutoplay = false;
    int interval = 3000;
    int transitionTime = 700;

    if (widget.content != null) {
      shouldAutoplay = widget.content!.autoplay;
      if (widget.content!.interval > 0) interval = widget.content!.interval;
      if (widget.content!.transitionTime > 0)
        transitionTime = widget.content!.transitionTime;
    } else if (widget.banners != null && widget.banners!.isNotEmpty) {
      shouldAutoplay = true;
    }

    if (shouldAutoplay && _items.length > 1) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: interval), (_) {
        if (!_controller.hasClients) return;
        int nextIndex = _currentIndex + 1;
        if (nextIndex >= _items.length) nextIndex = 0;
        _controller.animateToPage(
          nextIndex,
          duration: Duration(milliseconds: transitionTime),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void onTap(MobileBannerItems item) {
    debugPrint("Banner tapped: $item \n Product url ${item.url}");
    context.read<InteractionTestProvider>().addInteraction(
      ExotichomepageElement(
        createdAt: DateTime.now().toString(),
        interactionId: 1,
        interactionType: "homepage-element",
        updatedAt: DateTime.now().toString(),
        elementName: widget.title ?? "",
        elementType: "${widget.title}",
        tabBarName: "" ?? "",
      ),
    );
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

    double height = 160;
    double width = double.infinity;
    if (widget.content != null && widget.content!.height != 'auto') {
      try {
        height = double.parse(widget.content!.height.replaceAll('px', ''));
      } catch (_) {}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner Section Header (optional)
        if (widget.title != null && widget.title!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SectionHeader(title: widget.title!),
          ),

        // Carousel container with rounded corners & shadow
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              itemCount: items.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => onTap(item),
                  child: SizedBox(
                    width: double.infinity,
                    height: height,
                    child: Builder(
                      builder: (context) {
                        if (item is MobileBannerItems) {
                          if (!item.imageBase64Url.startsWith('http')) {
                            try {
                              final bytes = base64ToBytes(item.imageBase64Url);
                              return Image.memory(
                                bytes,
                                height: height,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            } catch (e) {
                              debugPrint("Error decoding base64 image: $e");
                              return Container(
                                height: height,
                                width: width,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              );
                            }
                          } else {
                            return AppCachedImage(
                              imageUrl: item.imageBase64Url,
                              height: height,
                              width: width,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(16),
                            );
                          }
                        } else if (item is BannerItem) {
                          final imageUrl = (api ?? "") + item.imageFile;
                          return AppCachedImage(
                            imageUrl: imageUrl,
                            height: height,
                            width: width,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(16),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Dot indicator
        if (items.length > 1) ...[
          const SizedBox(height: 10),
          DotsIndicator(count: items.length, currentIndex: _currentIndex),
        ],
      ],
    );
  }
}

/// Reusable section header widget used across multiple home sections
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -0.3,
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C3AED),
              ),
            ),
          ),
      ],
    );
  }
}
