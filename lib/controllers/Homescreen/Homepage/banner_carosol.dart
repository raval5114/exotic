import 'dart:async';
import 'package:exotic/Test/HomepagesTesting/model/bannertesting.dart';
import 'package:exotic/controllers/Homescreen/Homepage/src/dotIndicator.dart';
import 'package:exotic/utils/cachedImage.dart';
import 'package:flutter/material.dart';

class BannerCarouselWidget extends StatefulWidget {
  final BannerContent content;

  const BannerCarouselWidget({super.key, required this.content});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  String? api;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.content.autoplay && widget.content.banners.isNotEmpty) {
      _timer = Timer.periodic(Duration(milliseconds: widget.content.interval), (
        _,
      ) {
        if (!_controller.hasClients) return;

        _currentIndex = (_currentIndex + 1) % widget.content.banners.length;
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
    if (widget.content.banners.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.content.banners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final banner = widget.content.banners[index];

              return GestureDetector(
                onTap: () {
                  debugPrint("${banner.imageFile}");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppCachedImage(
                      imageUrl:
                          "https://xotic.in/UploadImages/ElementImages/" +
                          banner.imageFile,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        //
        // DotsIndicator(
        //   count: widget.content.banners.length,
        //   currentIndex: _currentIndex,
        // ),
      ],
    );
  }
}
