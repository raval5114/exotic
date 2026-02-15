import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class AdImageCarouselComponent extends StatefulWidget {
  const AdImageCarouselComponent({super.key});

  @override
  State<AdImageCarouselComponent> createState() =>
      _AdImageCarouselComponentState();
}

class _AdImageCarouselComponentState extends State<AdImageCarouselComponent> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomepageBloc>().add(HomePageAdImagesFetchingEvent());
  }

  @override
  Widget build(BuildContext context) {
    final double carouselHeight = MediaQuery.of(context).size.width * 0.45;

    return BlocConsumer<HomepageBloc, HomepageState>(
      listenWhen: (prev, curr) => curr is HomePageActionState,
      buildWhen: (prev, curr) => curr is! HomePageActionState,
      listener: (_, __) {},
      builder: (context, state) {
        if (state is HomepageLoadingState) {
          return _buildShimmer(carouselHeight);
        } else if (state is HomepageAddImageSuccessState) {
          return _buildCarousel(state.imagePath, carouselHeight);
        } else if (state is HomepageErrorState) {
          return _buildError(state.errMsg);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmer(double height) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> imagePaths, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          CarouselSlider(
            items:
                imagePaths.map((path) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      path,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image),
                            ),
                          ),
                    ),
                  );
                }).toList(),
            options: CarouselOptions(
              height: height,
              autoPlay: true,
              viewportFraction: 1.0,
              onPageChanged: (index, _) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String errMsg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          "Error: $errMsg",
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
