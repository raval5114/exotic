import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImage {
  final String image;
  final bool is360;

  ProductImage({required this.image, required this.is360});

  factory ProductImage.fromString(String image) {
    return ProductImage(image: image, is360: false);
  }

  factory ProductImage.placeholder() {
    return ProductImage(image: "placeholder.png", is360: false);
  }
}

class ProductCarousel extends StatefulWidget {
  final List<ProductImage> imageMaps;
  final double height;

  const ProductCarousel({
    super.key,
    required this.imageMaps,
    required this.height,
  });

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _currentIndex = 0;

  List<ProductImage> get _safeImages {
    if (widget.imageMaps.isEmpty) {
      return [ProductImage.placeholder()];
    }
    return widget.imageMaps;
  }

  @override
  void didUpdateWidget(covariant ProductCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_currentIndex >= _safeImages.length) {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = _safeImages;

    return Column(
      children: [
        CarouselSlider(
          items:
              images.map((item) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.network(
                        "https://xotic.in/UploadImages/Variant/${item.image}",
                        width: double.infinity,
                        height: widget.height,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            height: widget.height,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) {
                          return Container(
                            height: widget.height,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 48),
                            ),
                          );
                        },
                      ),

                      if (item.is360)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Center(child: _Tap360Button(onTap: () {})),
                        ),
                    ],
                  ),
                );
              }).toList(),
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        const SizedBox(height: 12),

        /// ✅ Render indicator ONLY when count > 1
        if (images.length > 1)
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: images.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
              activeDotColor: Colors.deepPurple,
              dotColor: Colors.grey,
            ),
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _Tap360Button extends StatelessWidget {
  final VoidCallback onTap;

  const _Tap360Button({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(24),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.threesixty, size: 18),
              const SizedBox(width: 8),
              Text("Tap to see in 360°", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
