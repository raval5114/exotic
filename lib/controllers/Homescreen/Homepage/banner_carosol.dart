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
  String? api = "https://xotic.in/UploadImages/ElementImages/";
  Timer? _timer;
  BannerContent? content;
  void onTap() {
    debugPrint("yas its working");
  }

  @override
  void initState() {
    super.initState();
    content = widget.content;
    if (content!.autoplay && content!.banners.isNotEmpty) {
      _timer = Timer.periodic(Duration(milliseconds: content!.interval), (_) {
        if (!_controller.hasClients) return;

        _currentIndex = (_currentIndex + 1) % content!.banners.length;
        _controller.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: content!.transitionTime),
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
    if (content!.banners.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: content!.banners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final banner = content!.banners[index];

              return GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppCachedImage(
                      imageUrl: api! + banner.imageFile,
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
      ],
    );
  }
}
