import 'package:carousel_slider/carousel_slider.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class HomePageItemShowingSection extends StatefulWidget {
  final String title;
  final int frontItemLength;
  final List<Map<String, dynamic>> itemList;
  final bool useCarousel;
  final int rows;
  final int columns;

  const HomePageItemShowingSection({
    super.key,
    required this.title,
    required this.itemList,
    required this.frontItemLength,
    this.useCarousel = false,
    this.rows = 1,
    this.columns = 2,
  });

  @override
  State<HomePageItemShowingSection> createState() =>
      _HomePageItemShowingSectionState();
}

class _HomePageItemShowingSectionState
    extends State<HomePageItemShowingSection> {
  static const double itemWidth = 148;
  static const double itemHeight = 252;
  static const double itemSpacing = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomepageBloc>().add(
          HomePageSectionFetchingEvent(productsitmes: widget.itemList),
        );
      }
    });
  }

  double _calculateHeight() {
    final itemsToShowCount =
        widget.itemList.take(widget.frontItemLength).length;
    final actualRows =
        itemsToShowCount < widget.rows ? itemsToShowCount : widget.rows;
    final rowsToUse = actualRows == 0 ? 1 : actualRows;
    return (itemHeight * rowsToUse) + (itemSpacing * (rowsToUse - 1));
  }

  // ── Product card ─────────────────────────────────────────────────────────
  Widget _buildItemCard(Map<String, dynamic> item, VoidCallback onTap) {
    final String name = item['productName'] ?? '';
    final double discountedPrice =
        (item['discountedPrice'] as num?)?.toDouble() ?? 0;
    final double initialPrice = (item['initialPrice'] as num?)?.toDouble() ?? 0;
    final int discount = (item['discount'] as num?)?.toInt() ?? 0;
    final num rating = (item['ratings'] as num?) ?? 0;
    final bool isFreeDelivery = item['isFreeDelivery'] == true;

    // Image: may be a List<String> of asset paths or a single String
    String? imagePath;
    final raw = item['imgages'];
    if (raw is List && raw.isNotEmpty) {
      imagePath = raw.first as String?;
    } else if (raw is String) {
      imagePath = raw;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image area ───────────────────────────────────────────
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image / placeholder
                    imagePath != null
                        ? Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => _buildImagePlaceholder(),
                        )
                        : _buildImagePlaceholder(),

                    // Discount badge
                    if (discount > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$discount% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),

                    // Wishlist button (top-right)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 15,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info area ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Rating stars
                    if (rating > 0)
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            return Icon(
                              i < rating.round()
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 11,
                              color: Colors.amber.shade600,
                            );
                          }),
                          const SizedBox(width: 3),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 5),

                    // Price row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${discountedPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            color: Color(0xFF111111),
                          ),
                        ),
                        if (initialPrice > discountedPrice) ...[
                          const SizedBox(width: 5),
                          Text(
                            '₹${initialPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 10.5,
                              color: Colors.grey.shade400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Free delivery badge
                    if (isFreeDelivery) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping_outlined,
                            size: 10,
                            color: Color(0xFF1B8A5A),
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Free Delivery',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B8A5A),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 32,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  // ── Shimmer card ─────────────────────────────────────────────────────────
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      period: const Duration(milliseconds: 1000),
      child: Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ── Section header — same visual style as ad_block product carousel ───────
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Row(
        children: [
          // Accent bar
          Container(
            width: 3.5,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF9747FF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          // Title
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          // "See All" arrow button
          GestureDetector(
            onTap: () => context.push('/productsTesting'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7B2FF7),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: Color(0xFF7B2FF7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Horizontal item grid ─────────────────────────────────────────────────
  Widget _buildItemGrid(List<Map<String, dynamic>> itemsToShow) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 14, right: 4),
      child: Row(
        children: List.generate((itemsToShow.length / widget.rows).ceil(), (
          columnIndex,
        ) {
          final columnItems = List.generate(widget.rows, (rowIndex) {
            final index = columnIndex * widget.rows + rowIndex;
            if (index >= itemsToShow.length) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex < widget.rows - 1 ? itemSpacing : 0,
              ),
              child: _buildItemCard(itemsToShow[index], () {
                final item = itemsToShow[index];
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    context.pushNamed('productScreen', extra: item);
                  }
                });
              }),
            );
          });

          return Padding(
            padding: const EdgeInsets.only(right: itemSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: columnItems,
            ),
          );
        }),
      ),
    );
  }

  // ── Carousel mode ────────────────────────────────────────────────────────
  Widget _buildCarousel(List<Map<String, dynamic>> itemsToShow) {
    return CarouselSlider(
      options: CarouselOptions(
        height: _calculateHeight(),
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {},
      ),
      items:
          itemsToShow.map((item) {
            final raw = item['imgages'];
            String? path;
            if (raw is List && raw.isNotEmpty) {
              path = raw.first as String?;
            } else if (raw is String) {
              path = raw;
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child:
                  path != null
                      ? Image.asset(
                        path,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      )
                      : _buildImagePlaceholder(),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = widget.itemList.take(widget.frontItemLength).toList();

    return BlocConsumer<HomepageBloc, HomepageState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isLoading = state is HomepageLoadingState;

        final content =
            isLoading
                // Shimmer list
                ? SizedBox(
                  height: _calculateHeight(),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.frontItemLength,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    separatorBuilder:
                        (_, __) => const SizedBox(width: itemSpacing),
                    itemBuilder: (_, __) => _buildShimmerCard(),
                  ),
                )
                : widget.useCarousel
                // Carousel
                ? _buildCarousel(itemsToShow)
                // Horizontal grid
                : SizedBox(
                  height: _calculateHeight(),
                  child: _buildItemGrid(itemsToShow),
                );

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildSectionHeader(), content],
          ),
        );
      },
    );
  }
}
