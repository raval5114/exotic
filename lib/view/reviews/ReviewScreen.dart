import 'package:exotic/data/blocs/reviews/reviews_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ReviewScreen extends StatelessWidget {
  final int testingProductId = 60; // Represents the mocked product id

  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ReviewsBloc()..add(FetchReviewsEvent(testingProductId)),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            "All Reviews",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 1,
        ),
        body: const _ReviewsTestBody(),
      ),
    );
  }
}

class AnimatedActionPill extends StatefulWidget {
  final IconData defaultIcon;
  final IconData activeIcon;
  final String text;

  const AnimatedActionPill({
    super.key,
    required this.defaultIcon,
    required this.activeIcon,
    required this.text,
  });

  @override
  State<AnimatedActionPill> createState() => _AnimatedActionPillState();
}

class _AnimatedActionPillState extends State<AnimatedActionPill> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isActive ? widget.activeIcon : widget.defaultIcon,
                key: ValueKey<bool>(isActive),
                size: 16,
                color: isActive ? Colors.blue : Colors.black54,
              ),
            ),
            if (widget.text.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                widget.text,
                style: TextStyle(
                  color: isActive ? Colors.blue : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ReviewSummaryHeader extends StatelessWidget {
  final dynamic summary;
  const ReviewSummaryHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildPill("Overall", true),
              const SizedBox(width: 8),
              _buildPill("Camera", false),
              const SizedBox(width: 8),
              _buildPill("Battery", false),
              const SizedBox(width: 8),
              _buildPill("Performance", false),
              const SizedBox(width: 8),
              _buildPill("Display", false),
            ],
          ),
        ),
        Container(height: 8, color: Colors.grey[200]),

        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              // Left
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        double rating =
                            double.tryParse(summary.averageRating.toString()) ??
                            5.0;
                        return Icon(
                          Icons.star,
                          color:
                              i < rating.round()
                                  ? Colors.green[700]
                                  : Colors.grey[300],
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "42,391 ratings and\n${summary.totalReviews} reviews",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(width: 1, height: 70, color: Colors.grey[300]),
              const SizedBox(width: 16),
              // Right
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildProgressBar(
                      5,
                      summary.rating5Count ?? 29863,
                      Colors.green[700]!,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      4,
                      summary.rating4Count ?? 7906,
                      Colors.green[600]!,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      3,
                      summary.rating3Count ?? 1949,
                      Colors.green[400]!,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      2,
                      summary.rating2Count ?? 736,
                      Colors.lightGreen,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      1,
                      summary.rating1Count ?? 1937,
                      Colors.red[400]!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal Image Scroller
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.grey.shade200,
                  child: Image.network(
                    "https://picsum.photos/seed/header$idx/200",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (ctx, _, __) => const SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(height: 8, color: Colors.grey[200]),

        // Sorting tabs
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "User reviews sorted by",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildPill("Most Helpful", true),
              const SizedBox(width: 8),
              _buildPill("Latest", false),
              const SizedBox(width: 8),
              _buildPill("Positive", false),
              const SizedBox(width: 8),
              _buildPill("Negative", false),
            ],
          ),
        ),
        Divider(thickness: 1, height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildPill(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProgressBar(int stars, int count, Color color) {
    return Row(
      children: [
        Text(
          "$stars \u2605",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count == 0 ? 0 : (count / 30000.0).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            count.toString(),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _ReviewsTestBody extends StatelessWidget {
  const _ReviewsTestBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsBloc, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewActionSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ReviewActionErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      buildWhen:
          (previous, current) =>
              current is ReviewsLoadedState ||
              current is ReviewsLoadingState ||
              current is ReviewsErrorState,
      builder: (context, state) {
        if (state is ReviewsLoadingState || state is ReviewsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ReviewsErrorState) {
          return Center(
            child: Text(
              "Error: ${state.errorMessage}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is ReviewsLoadedState) {
          final reviews = state.reviewsData.reviews;
          return ListView.builder(
            itemCount: reviews.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ReviewSummaryHeader(summary: state.reviewsData.summary);
              }
              final review = reviews[index - 1];
              final double rating =
                  double.tryParse(review.overallRating) ?? 5.0;
              final bool isVerified = review.isVerifiedPurchase == 1;

              return Column(
                children: [
                  if (index > 1)
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TOP ROW: Stars + Title
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color:
                                      i < rating.round()
                                          ? Colors.green[700]
                                          : Colors.grey[300],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review.overallRating,
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                "•",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                review.reviewTitle,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Variant text (mocked)
                        Text(
                          "Review for: Standard Variant • Default Size",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Main text
                        Text(
                          review.reviewText,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Simulated Images List
                        if (review.reviewImages.isEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, imgIndex) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    child: Image.network(
                                      "https://picsum.photos/seed/${review.reviewId}$imgIndex/200",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (ctx, _, __) => const SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Customer Name
                        Text(
                          "${review.customerName}",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Helpful Actions
                        Row(
                          children: [
                            AnimatedActionPill(
                              defaultIcon: Icons.thumb_up_outlined,
                              activeIcon: Icons.thumb_up,
                              text:
                                  "Helpful for ${review.helpfulCount > 0 ? review.helpfulCount : '0'}",
                            ),
                            const SizedBox(width: 12),
                            if (review.notHelpfulCount > 0)
                              AnimatedActionPill(
                                defaultIcon: Icons.thumb_down_outlined,
                                activeIcon: Icons.thumb_down,
                                text: "${review.notHelpfulCount}",
                              )
                            else
                              const AnimatedActionPill(
                                defaultIcon: Icons.thumb_down_outlined,
                                activeIcon: Icons.thumb_down,
                                text: "",
                              ),
                            const Spacer(),
                            const Icon(
                              Icons.more_vert,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Verified Purchase + Date
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color:
                                  isVerified ? Colors.black : Colors.grey[400],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isVerified
                                  ? "Verified Purchase"
                                  : "Unverified Purchase",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                "•",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                            Text(
                              review.createdAtFormatted.isNotEmpty
                                  ? review.createdAtFormatted
                                  : "Recent",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
