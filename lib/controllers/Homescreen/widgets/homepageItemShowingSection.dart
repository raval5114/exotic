import 'package:carousel_slider/carousel_slider.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/view/products/productScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int _carouselIndex = 0;

  static const double itemWidth = 140;
  static const double itemHeight = 220;
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

  Widget _buildItemCard(Map<String, dynamic> item, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const Placeholder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['productName'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '₹${item['discountedPrice']}',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${item['initialPrice']}',
                  style: GoogleFonts.roboto(
                    fontSize: 12.5,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 800),
      child: Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTitleRow(VoidCallback onTap) {
    return Row(
      children: [
        Text(
          widget.title,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const Spacer(),
        InkWell(
          onTap: () => context.push('/productsTesting'),
          child: const Icon(Icons.arrow_forward_ios, size: 18),
        ),
      ],
    );
  }

  Widget _buildItemGrid(List<Map<String, dynamic>> itemsToShow) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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

  Widget _buildCarousel(List<Map<String, dynamic>> itemsToShow) {
    return CarouselSlider(
      options: CarouselOptions(
        height: _calculateHeight(),
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          if (!mounted) return;
          setState(() {
            _carouselIndex = index;
          });
        },
      ),
      items:
          itemsToShow
              .map(
                (path) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    path['imagepath'],
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              )
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = widget.itemList.take(widget.frontItemLength).toList();

    return BlocConsumer<HomepageBloc, HomepageState>(
      listener: (context, state) {},
      builder: (context, state) {
        final content =
            (state is HomepageLoadingState)
                ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.frontItemLength,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder:
                      (_, __) => const SizedBox(width: itemSpacing),
                  itemBuilder: (_, __) => _buildShimmerCard(),
                )
                : widget.useCarousel
                ? _buildCarousel(itemsToShow)
                : _buildItemGrid(itemsToShow);

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(() {}),
                const SizedBox(height: 12),
                SizedBox(height: _calculateHeight(), child: content),
              ],
            ),
          ),
        );
      },
    );
  }
}
