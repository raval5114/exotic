import 'package:exotic/data/blocs/reviews/reviews_bloc.dart';
import 'package:exotic/data/models/reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/data/providers/reviews_provider.dart';
import 'package:exotic/controllers/products/shared/src/productReviewIsHelpfull.dart';

class Productratingsandreviewscomponents extends StatefulWidget {
  final int productId;

  const Productratingsandreviewscomponents({
    super.key,
    required this.productId,
  });

  @override
  State<Productratingsandreviewscomponents> createState() =>
      _ProductratingsandreviewscomponentsState();
}

class _ProductratingsandreviewscomponentsState
    extends State<Productratingsandreviewscomponents> {
  late ReviewsBloc _reviewsBloc;
  final ReviewsProvider _reviewsProvider = ReviewsProvider();

  bool _sectionExpanded = true;

  @override
  void initState() {
    super.initState();
    _reviewsBloc = ReviewsBloc()..add(FetchReviewsEvent(widget.productId));
  }

  @override
  void didUpdateWidget(covariant Productratingsandreviewscomponents oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _reviewsBloc.add(FetchReviewsEvent(widget.productId));
    }
  }

  @override
  void dispose() {
    _reviewsBloc.close();
    super.dispose();
  }

  String _getRatingDescriptor(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 3.5) return 'Good';
    if (rating >= 2.5) return 'Average';
    if (rating >= 1.5) return 'Poor';
    return 'Very Poor';
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return const Color(0xFF1B8A5A);
    if (rating >= 3.0) return const Color(0xFFF5A623);
    return const Color(0xFFE53935);
  }

  // ── Collapsible section header ──────────────────────────────────────────
  Widget _buildSectionHeader({
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: () => setState(() => _sectionExpanded = !_sectionExpanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                    fontFamily: 'Roboto',
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ],
            ),
            Row(
              children: [
                if (trailing != null) ...[trailing, const SizedBox(width: 8)],
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _sectionExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _reviewsBloc,
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 4),
        child: BlocConsumer<ReviewsBloc, ReviewsState>(
          listener: (context, state) {
            if (state is ReviewsLoadedState) {
              _reviewsProvider.setReviewsData(state.reviewsData);
            }
          },
          builder: (context, state) {
            // ── Loading ─────────────────────────────────────────────────
            if (state is ReviewsInitial || state is ReviewsLoadingState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(title: 'Ratings & Reviews'),
                  if (_sectionExpanded) _buildShimmer(),
                ],
              );
            }

            // ── Error ────────────────────────────────────────────────────
            if (state is ReviewsErrorState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(title: 'Ratings & Reviews'),
                  if (_sectionExpanded)
                    _buildErrorState(context, state.errorMessage),
                ],
              );
            }

            // ── Loaded ───────────────────────────────────────────────────
            if (state is ReviewsLoadedState) {
              final reviewsData = state.reviewsData;
              final summary = reviewsData.summary;
              final reviews = reviewsData.reviews;
              final avgRating =
                  double.tryParse(summary.averageRating) ?? 0.0;

              final subtitle =
                  summary.totalReviews > 0
                      ? '${summary.totalReviews} ratings · ${_getRatingDescriptor(avgRating)}'
                      : 'No reviews yet';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header with "View All" trailing action
                  _buildSectionHeader(
                    title: 'Ratings & Reviews',
                    subtitle: subtitle,
                    trailing:
                        summary.totalReviews > 0
                            ? GestureDetector(
                              onTap: () => context.push(
                                '/reviews',
                                extra: _reviewsProvider,
                              ),
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            )
                            : null,
                  ),

                  if (_sectionExpanded) ...[
                    const Divider(
                      height: 1,
                      thickness: 0.8,
                      color: Color(0xFFEEEEEE),
                      indent: 16,
                      endIndent: 16,
                    ),
                    const SizedBox(height: 16),

                    if (reviews.isEmpty)
                      _buildEmptyState()
                    else ...[
                      // Rating summary block
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildRatingSummary(
                          context,
                          summary,
                          avgRating,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFEEEEEE),
                        indent: 16,
                        endIndent: 16,
                      ),
                      const SizedBox(height: 4),

                      // Reviews list (up to 3)
                      ...reviews.take(3).toList().asMap().entries.map((entry) {
                        final idx = entry.key;
                        final review = entry.value;
                        final isLast =
                            idx == (reviews.take(3).length - 1) ||
                            idx == 2;
                        return Column(
                          children: [
                            _buildReviewCard(context, review),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                thickness: 0.6,
                                color: Color(0xFFEEEEEE),
                                indent: 16,
                                endIndent: 16,
                              ),
                          ],
                        );
                      }),

                      // "All X reviews" footer
                      if (summary.totalReviews > 3) ...[
                        const Divider(
                          height: 1,
                          thickness: 0.8,
                          color: Color(0xFFEEEEEE),
                        ),
                        InkWell(
                          onTap: () => context.push(
                            '/reviews',
                            extra: _reviewsProvider,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All ${summary.totalReviews} reviews',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111111),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 22,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 8),
                  ],
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ── Rating summary (big number + bars) ──────────────────────────────────
  Widget _buildRatingSummary(
    BuildContext context,
    dynamic summary,
    double avgRating,
  ) {
    final ratingColor = _getRatingColor(avgRating);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: big number + stars + label
        SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: ratingColor,
                  fontFamily: 'Roboto',
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return Icon(
                    i < avgRating.round()
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 16,
                    color: ratingColor,
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                _getRatingDescriptor(avgRating),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: ratingColor,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${summary.totalReviews} ratings',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade500,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Right: horizontal rating bars
        Expanded(
          child: Column(
            children: [
              _buildRatingBar(context, '5', summary.rating5Count,
                  summary.totalReviews),
              _buildRatingBar(context, '4', summary.rating4Count,
                  summary.totalReviews),
              _buildRatingBar(context, '3', summary.rating3Count,
                  summary.totalReviews),
              _buildRatingBar(context, '2', summary.rating2Count,
                  summary.totalReviews),
              _buildRatingBar(context, '1', summary.rating1Count,
                  summary.totalReviews),
            ],
          ),
        ),
      ],
    );
  }

  // ── Individual review card ───────────────────────────────────────────────
  Widget _buildReviewCard(BuildContext context, Review review) {
    final rating = double.tryParse(review.overallRating) ?? 0.0;
    final ratingColor = _getRatingColor(rating);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User row
          Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: ratingColor.withValues(alpha: 0.12),
                child: Text(
                  review.customerName.isNotEmpty
                      ? review.customerName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ratingColor,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        // Rating badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: ratingColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                review.overallRating,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: 11,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (review.isVerifiedPurchase == 1) ...[
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF1B8A5A),
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade500,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.createdAtFormatted,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade400,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          if (review.reviewTitle.isNotEmpty) ...[
            Text(
              review.reviewTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 4),
          ],

          // Body
          Text(
            review.reviewText,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey.shade700,
              fontFamily: 'Roboto',
              height: 1.5,
            ),
          ),

          // Sub-ratings (Quality / Value / Delivery)
          if (review.qualityRating.isNotEmpty ||
              review.valueRating.isNotEmpty ||
              review.deliveryRating.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (review.qualityRating.isNotEmpty)
                  _buildSubRatingChip('Quality', review.qualityRating),
                if (review.valueRating.isNotEmpty)
                  _buildSubRatingChip('Value', review.valueRating),
                if (review.deliveryRating.isNotEmpty)
                  _buildSubRatingChip('Delivery', review.deliveryRating),
              ],
            ),
          ],

          // Pros & Cons
          if (review.pros.isNotEmpty || review.cons.isNotEmpty) ...[
            const SizedBox(height: 10),
            if (review.pros.isNotEmpty)
              _buildProConRow(
                icon: Icons.check_circle_outline_rounded,
                label: 'Pros',
                value: review.pros,
                color: const Color(0xFF1B8A5A),
              ),
            if (review.cons.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: review.pros.isNotEmpty ? 6 : 0),
                child: _buildProConRow(
                  icon: Icons.cancel_outlined,
                  label: 'Cons',
                  value: review.cons,
                  color: Colors.redAccent,
                ),
              ),
          ],

          // Review images
          if (review.reviewImages.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 68,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.reviewImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      review.reviewImages[idx],
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 68,
                        height: 68,
                        color: Colors.grey.shade100,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Seller response
          if (review.vendorResponse != null &&
              review.vendorResponse!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEAEAEA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        size: 15,
                        color: Color(0xFF555555),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Seller Response',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const Spacer(),
                      if (review.vendorResponseDate != null)
                        Text(
                          review.vendorResponseDate!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.vendorResponse!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Helpful buttons
          Productreviewishelpfull(review: review),
        ],
      ),
    );
  }

  // ── Rating bar row ────────────────────────────────────────────────────────
  Widget _buildRatingBar(
    BuildContext context,
    String star,
    int count,
    int total,
  ) {
    final pct = total > 0 ? count / total : 0.0;

    Color barColor;
    if (star == '5' || star == '4') {
      barColor = const Color(0xFF1B8A5A);
    } else if (star == '3') {
      barColor = const Color(0xFFF5A623);
    } else {
      barColor = const Color(0xFFE53935);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            star,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFCCCCCC)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: const Color(0xFFEEEEEE),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 7,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 26,
            child: Text(
              count.toString(),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade500,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sub-rating chip ──────────────────────────────────────────────────────
  Widget _buildSubRatingChip(String label, String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey.shade600,
              fontFamily: 'Roboto',
            ),
          ),
          const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
          const SizedBox(width: 3),
          Text(
            rating,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  // ── Pros / Cons row ──────────────────────────────────────────────────────
  Widget _buildProConRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: color,
            fontFamily: 'Roboto',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF444444),
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ],
    );
  }

  // ── Shimmer loading state ─────────────────────────────────────────────────
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary block placeholder
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: List.generate(
                      5,
                      (_) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Review card placeholders
            ...List.generate(
              2,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 110,
                              height: 13,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 70,
                              height: 11,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 220,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
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
  }

  // ── Empty state ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 44,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Be the first to review this product',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade400,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildErrorState(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 44,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load reviews',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () =>
                  context.read<ReviewsBloc>().add(
                    FetchReviewsEvent(widget.productId),
                  ),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
