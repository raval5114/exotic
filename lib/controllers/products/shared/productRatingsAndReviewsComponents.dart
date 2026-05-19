import 'package:exotic/data/blocs/reviews/reviews_bloc.dart';
import 'package:exotic/data/models/reviews.dart';
import 'package:exotic/view/products/allReviewsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/data/providers/reviews_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize the BLoC and fire the fetching event instantly
    _reviewsBloc = ReviewsBloc()..add(FetchReviewsEvent(widget.productId));
  }

  @override
  void didUpdateWidget(covariant Productratingsandreviewscomponents oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Automatically refetch if the product ID completely changes without leaving the screen
    if (oldWidget.productId != widget.productId) {
      _reviewsBloc.add(FetchReviewsEvent(widget.productId));
    }
  }

  @override
  void dispose() {
    // Explicitly dispose of the BLoC the moment this component/screen is removed from the tree
    _reviewsBloc.close();
    super.dispose();
  }

  String _getRatingDescriptor(double rating) {
    if (rating >= 4.5) return "Excellent";
    if (rating >= 3.5) return "Good";
    if (rating >= 2.5) return "Average";
    if (rating >= 1.5) return "Poor";
    return "Very Poor";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _reviewsBloc,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 60),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Internal Builder handles states dynamically
            BlocConsumer<ReviewsBloc, ReviewsState>(
              listener: (context, state) {
                if (state is ReviewsLoadedState) {
                  _reviewsProvider.setReviewsData(state.reviewsData);
                }
              },
              builder: (context, state) {
                if (state is ReviewsInitial || state is ReviewsLoadingState) {
                  return _buildHeaderAndShimmer();
                }

                if (state is ReviewsErrorState) {
                  return _buildHeaderAndError(context, state.errorMessage);
                }

                if (state is ReviewsLoadedState) {
                  final reviewsData = state.reviewsData;
                  final summary = reviewsData.summary;
                  final reviews = reviewsData.reviews;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with View All Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ratings & Reviews",
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (summary.totalReviews > 0)
                            InkWell(
                              onTap: () {
                                context.push(
                                  '/reviews',
                                  extra: _reviewsProvider,
                                );
                              },
                              child: Text(
                                "View All",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (reviews.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              "No reviews found for this product.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else ...[
                        // Quick Summary
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                summary.averageRating,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        Icons.star_rounded,
                                        size: 20,
                                        color:
                                            index <
                                                    double.parse(
                                                      summary.averageRating,
                                                    ).round()
                                                ? Colors.amber
                                                : Colors.grey[300],
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${summary.totalReviews} Ratings & ${summary.totalReviews} Reviews",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Dynamic list of up to 3 reviews for brief view
                        ...reviews.take(3).toList().asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final review = entry.value;
                          return Column(
                            children: [
                              _buildReviewCard(context, review),
                              if (index != reviews.take(3).length - 1)
                                const Divider(thickness: 0.5, height: 24),
                            ],
                          );
                        }),

                        // Footer for More Reviews
                        if (summary.totalReviews > 3) ...[
                          const Divider(
                            thickness: 1,
                            height: 1,
                            color: Colors.black12,
                          ),
                          InkWell(
                            onTap: () {
                              context.push('/reviews', extra: _reviewsProvider);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "All ${summary.totalReviews} reviews",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall?.copyWith(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAndShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ratings & Reviews",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Divider(thickness: 0.5),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 40,
                    color: Colors.white,
                    padding: const EdgeInsets.all(4),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 100, height: 16, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(width: 140, height: 12, color: Colors.white),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...List.generate(
                2,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 100,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(width: 200, height: 14, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderAndError(BuildContext context, String error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Ratings & Reviews",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed:
                  () => context.read<ReviewsBloc>().add(
                    FetchReviewsEvent(widget.productId),
                  ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Retry"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(thickness: 0.5),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red[300],
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  "Failed to load reviews.",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User avatar, Rating & Date
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.5),
                child: Text(
                  review.customerName.isNotEmpty
                      ? review.customerName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
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
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Text(
                                review.overallRating,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (review.isVerifiedPurchase == 1)
                          const Row(
                            children: [
                              Icon(
                                Icons.verified,
                                color: Colors.grey,
                                size: 14,
                              ),
                              SizedBox(width: 3),
                              Text(
                                "Verified Purchase",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.createdAtFormatted,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (review.reviewTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                review.reviewTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

          Text(
            review.reviewText,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
