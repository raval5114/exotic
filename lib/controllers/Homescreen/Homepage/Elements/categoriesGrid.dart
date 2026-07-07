import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesGrid extends StatefulWidget {
  final String? tabName;
  const CategoriesGrid({super.key, this.tabName});

  @override
  State<CategoriesGrid> createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  @override
  void initState() {
    super.initState();
    context.read<HomepageBloc>().add(
      HomePageCategoriesFetchingEvent(
        categories: context.read<CategoriesProvider>().categories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title
        const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: Text(
            "Shop by Category",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
        ),

        BlocBuilder<HomepageBloc, HomepageState>(
          buildWhen:
              (previous, current) =>
                  current is HomepageLoadingState ||
                  current is HomePageCategoriesFetchedState ||
                  current is HomepageErrorState,
          builder: (context, state) {
            /// Loading shimmer
            if (state is HomepageLoadingState) {
              return _buildShimmer();
            }

            if (state is HomePageCategoriesFetchedState) {
              final categories = state.categories;

              if (categories.isEmpty) {
                return const Center(child: Text("No categories available"));
              }

              return _buildScrollableGrid(context, categories);
            }

            /// Error state
            if (state is HomepageErrorState) {
              return Center(child: Text("Error: ${state.errMsg}"));
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Horizontally scrollable 2-row grid matching the design image
  Widget _buildScrollableGrid(BuildContext context, List categories) {
    const double itemSpacing = 10.0;
    const int rowCount = 2;
    const double itemHeight = 110.0; // image height + label height

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // Show ~5.5 items to hint scrollability
        const double itemsVisible = 5.5;
        final double itemWidth =
            (totalWidth - (itemSpacing * (itemsVisible - 1))) / itemsVisible;

        return SizedBox(
          height: (itemHeight * rowCount) + itemSpacing,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowCount,
              crossAxisSpacing: itemSpacing,
              mainAxisSpacing: itemSpacing,
              childAspectRatio: itemHeight / itemWidth,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryItem(
                name: category.name,
                imageUrl: category.url,
                photo: category.photo,
                tabName: widget.tabName ?? '',
              );
            },
          ),
        );
      },
    );
  }

  /// Shimmer placeholder matching same 2-row horizontal layout
  Widget _buildShimmer() {
    const double itemSpacing = 10.0;
    const int rowCount = 2;
    const double itemHeight = 110.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        const double itemsVisible = 5.5;
        final double itemWidth =
            (totalWidth - (itemSpacing * (itemsVisible - 1))) / itemsVisible;

        return SizedBox(
          height: (itemHeight * rowCount) + itemSpacing,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowCount,
              crossAxisSpacing: itemSpacing,
              mainAxisSpacing: itemSpacing,
              childAspectRatio: itemHeight / itemWidth,
            ),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String? photo;
  final String tabName;

  const _CategoryItem({
    required this.name,
    required this.imageUrl,
    required this.tabName,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<InteractionTestProvider>().addInteraction(
          ExotichomepageElement(
            createdAt: DateTime.now().toString(),
            interactionId: 1,
            interactionType: "homepageElement",
            updatedAt: DateTime.now().toString(),
            elementName: name,
            elementType: "category",
            tabBarName: tabName,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Image tile — fills the available space with rounded corners
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(),
            ),
          ),

          const SizedBox(height: 5),

          /// Category label
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 11.5,
              color: Color(0xFF111827),
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Prefer `photo` field (base64 or network), fallback to `url` (asset path)
    final src = (photo != null && photo!.isNotEmpty) ? photo! : imageUrl;

    if (src.isEmpty) {
      return _placeholder();
    }

    // Network URL
    if (src.startsWith('http://') || src.startsWith('https://')) {
      return Image.network(
        src,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _shimmerBox();
        },
      );
    }

    // Asset path
    return Image.asset(
      src,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(
          Icons.category_rounded,
          color: Color(0xFF9CA3AF),
          size: 26,
        ),
      ),
    );
  }

  Widget _shimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(color: Colors.white),
    );
  }
}
