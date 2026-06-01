import 'package:exotic/controllers/Homescreen/Homepage/pageComponent.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/homepage_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ExoticSliverBody extends StatelessWidget {
  final List<HomepagePageModel> tabs;

  const ExoticSliverBody({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return TabBarView(
      controller: controller,
      children: tabs.map((tab) {
        return BlocBuilder<HomepageBloc, HomepageState>(
          buildWhen: (previous, current) {
            if (current is HomepageTabLoadingState) {
              return current.slug == tab.slug;
            }
            if (current is HomepageApiFetchedState) {
              return current.slug == tab.slug;
            }
            return false;
          },
          builder: (context, state) {
            if (state is HomepageTabLoadingState &&
                state.slug == tab.slug) {
              return _buildShimmer();
            }

            if (state is HomepageApiFetchedState &&
                state.slug == tab.slug) {
              final Map<String, dynamic> pageData = state.data;
              return Pagecomponent(pageData: Pagemodel.fromJson(pageData));
            }

            return const SizedBox();
          },
        );
      }).toList(),
    );
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner shimmer
          _shimmerBox(height: 160, borderRadius: 16),
          const SizedBox(height: 12),

          // Row of dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (i) => Container(
                width: i == 0 ? 24 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Category grid shimmer
          _shimmerBox(height: 12, width: 140, borderRadius: 6),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section title shimmer
          _shimmerBox(height: 20, width: 180, borderRadius: 6),
          const SizedBox(height: 14),

          // Horizontal cards shimmer
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => _shimmerBox(
                height: 185,
                width: 148,
                borderRadius: 16,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section title shimmer
          _shimmerBox(height: 20, width: 160, borderRadius: 6),
          const SizedBox(height: 14),

          // Product grid shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, __) => _shimmerBox(borderRadius: 16),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    double? height,
    double? width,
    double borderRadius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
