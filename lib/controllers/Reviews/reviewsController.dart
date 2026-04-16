import 'package:exotic/controllers/Reviews/src/animationActionPill.dart';
import 'package:exotic/controllers/Reviews/src/reviewsSummaryHeader.dart';
import 'package:exotic/data/providers/reviews_provider.dart';
import 'package:exotic/data/models/reviews.dart';
import 'package:exotic/data/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/reviews/reviews_bloc.dart';

class ReviewsBody extends StatelessWidget {
  final ReviewsProvider reviewsProvider;

  const ReviewsBody({super.key, required this.reviewsProvider});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: reviewsProvider,
      builder: (context, child) {
        final reviewsData = reviewsProvider.reviewsData;

        if (reviewsData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = reviewsData.reviews;

        Widget list = ListView.builder(
          itemCount: reviews.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ReviewSummaryHeader(summary: reviewsData.summary);
            }
            final review = reviews[index - 1];
            final double rating = double.tryParse(review.overallRating) ?? 5.0;
            final bool isVerified = review.isVerifiedPurchase == 1;

            return Column(
              children: [
                if (index > 1)
                  Divider(thickness: 1, height: 1, color: Colors.grey.shade300),
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
                            padding: const EdgeInsets.symmetric(horizontal: 6),
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
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
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
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
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
                            color: isVerified ? Colors.black : Colors.grey[400],
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
                            padding: const EdgeInsets.symmetric(horizontal: 6),
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

        Widget bodyContent = list;

        if (appInitialLocation == '/productsTesting' ||
            appInitialLocation == '/productesting') {
          bodyContent = Scaffold(
            backgroundColor: Colors.transparent,
            body: list,
            floatingActionButton: FloatingActionButton.extended(
              onPressed:
                  () => _showAddReviewModal(
                    context,
                    reviewsData.summary.productId,
                    reviewsProvider,
                  ),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                "Add Review",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }

        return BlocListener<ReviewsBloc, ReviewsState>(
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
          child: bodyContent,
        );
      },
    );
  }

  void _showAddReviewModal(
    BuildContext context,
    int productId,
    ReviewsProvider provider,
  ) {
    final reviewsBloc = context.read<ReviewsBloc>();
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    final TextEditingController _prosController = TextEditingController();
    final TextEditingController _consController = TextEditingController();
    int _overallRating = 5;
    int _qualityRating = 5;
    int _valueRating = 5;
    int _deliveryRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget _buildRatingBar(
              String title,
              int currentRating,
              Function(int) onUpdate,
            ) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => onUpdate(index + 1)),
                        child: Icon(
                          Icons.star,
                          color:
                              index < currentRating
                                  ? Colors.amber
                                  : Colors.grey[300],
                          size: 28,
                        ),
                      );
                    }),
                  ),
                ],
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Write a Review",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRatingBar(
                      "Overall Rating",
                      _overallRating,
                      (v) => _overallRating = v,
                    ),
                    const SizedBox(height: 8),
                    _buildRatingBar(
                      "Quality",
                      _qualityRating,
                      (v) => _qualityRating = v,
                    ),
                    const SizedBox(height: 8),
                    _buildRatingBar(
                      "Value",
                      _valueRating,
                      (v) => _valueRating = v,
                    ),
                    const SizedBox(height: 8),
                    _buildRatingBar(
                      "Delivery",
                      _deliveryRating,
                      (v) => _deliveryRating = v,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Title (e.g. Good Quality)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Detailed Review",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: _prosController,
                      decoration: const InputDecoration(
                        labelText: "Pros",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _consController,
                      decoration: const InputDecoration(
                        labelText: "Cons",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          // Submit API Call explicitly formatting all strict parameters requested
                          reviewsBloc.add(
                            AddReviewEvent(
                              "5", // Mocked customer
                              productId,
                              _overallRating.toDouble(),
                              _qualityRating.toDouble(),
                              _valueRating.toDouble(),
                              _deliveryRating.toDouble(),
                              _titleController.text,
                              _descController.text,
                              _prosController.text,
                              _consController.text,
                              456, // Mocked Order ID
                              789, // Mocked Order Item ID
                            ),
                          );

                          // Fallback to instantly reflect it on UI state
                          provider.addReview(
                            Review(
                              reviewId: DateTime.now().millisecondsSinceEpoch,
                              productId: productId,
                              customerId: 5,
                              overallRating: _overallRating.toString(),
                              reviewTitle: _titleController.text,
                              reviewText: _descController.text,
                              reviewImages: [],
                              reviewVideos: [],
                              isVerifiedPurchase: 1,
                              helpfulCount: 0,
                              notHelpfulCount: 0,
                              customerName: "Test User",
                              createdAtFormatted: "Just now",
                              qualityRating: _qualityRating.toString(),
                              valueRating: _valueRating.toString(),
                              deliveryRating: _deliveryRating.toString(),
                              pros: _prosController.text,
                              cons: _consController.text,
                              isApproved: 1,
                              isFeatured: 0,
                              status: '',
                              reportCount: 0,
                              vendorResponse: null,
                              vendorResponseDate: null,
                              createdAt: DateTime.now().toIso8601String(),
                              updatedAt: DateTime.now().toIso8601String(),
                              customerEmail: '',
                              daysAgo: 0,
                              orderId: 456,
                              vendorId: 0,
                            ),
                          );
                          context.pop();
                        },
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
