import 'dart:async';
import 'package:exotic/controllers/Homescreen/Homepage/src/dotIndicator.dart';
import 'package:exotic/data/models/Homepage/elements/image_gallery.dart';
import 'package:exotic/utils/cachedImage.dart';
import 'package:flutter/material.dart';

class ImageGalleryCarouselWidget extends StatefulWidget {
  final ImageGalleryContent content;

  const ImageGalleryCarouselWidget({super.key, required this.content});

  @override
  State<ImageGalleryCarouselWidget> createState() =>
      _ImageGalleryCarouselWidgetState();
}

class _ImageGalleryCarouselWidgetState
    extends State<ImageGalleryCarouselWidget> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;
  ImageGalleryContent? content;

  ///Image Carosol Event
  ///
  /// On Image Click Event
  void onTap() {}

  @override
  void initState() {
    super.initState();
    content = widget.content;
    if (content!.autoplay && content!.items.isNotEmpty) {
      _timer = Timer.periodic(Duration(milliseconds: content!.interval), (_) {
        if (!_controller.hasClients) return;

        _currentIndex = (_currentIndex + 1) % widget.content.items.length;

        _controller.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: widget.content.transitionTime),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (content!.items.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Gallery Title
        if (content!.galleryTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              widget.content.galleryTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),

        // 🔹 Carousel
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: content!.items.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final item = content!.items[index];

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.content.gap / 2,
                ),
                child: GestureDetector(
                  onTap: onTap,
                  child: Stack(
                    children: [
                      //Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          _parseRadius(widget.content.imageRadius),
                        ),
                        child: AppCachedImage(
                          imageUrl: widget.content.items[index].imageUrl,
                          height: 200,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      // 🏷 Caption Overlay
                      if (item.caption.isNotEmpty ||
                          item.productTitle.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _parseColor(
                                widget.content.captionBackground,
                                fallback: Colors.black54,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.productTitle.isNotEmpty)
                                  Text(
                                    item.productTitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (item.caption.isNotEmpty)
                                  Text(
                                    item.caption,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // 🔹 Dots Indicator
        DotsIndicator(
          count: content!.items.length,
          currentIndex: _currentIndex,
        ),
      ],
    );
  }

  double _parseRadius(String value) {
    return double.tryParse(value.replaceAll('px', '')) ?? 0;
  }

  Color _parseColor(String value, {Color fallback = Colors.transparent}) {
    if (value.startsWith('#')) {
      final hex = value.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    }
    return fallback;
  }
}
