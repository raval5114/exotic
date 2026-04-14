import 'package:go_router/go_router.dart';
import 'package:exotic/data/blocs/reviews/reviews_bloc.dart';
import 'package:exotic/data/models/reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllReviewsScreen extends StatelessWidget {
  final int productId;

  const AllReviewsScreen({super.key, required this.productId});

  void _showAddReviewModal(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    int _selectedRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Write a Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: index < _selectedRating ? Colors.amber : Colors.grey[300],
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        // Pass simulated new review mapping
                        context.read<ReviewsBloc>().add(AddReviewEvent(
                          productId,
                          {
                            "overall_rating": _selectedRating.toString(),
                            "review_title": _titleController.text,
                            "review_text": _descController.text,
                          },
                        ));
                        context.pop();
                      },
                      child: const Text("Submit Review", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("All Reviews"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReviewModal(context),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("Add Review", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocListener<ReviewsBloc, ReviewsState>(
        listener: (context, state) {
          if (state is ReviewActionSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ));
          } else if (state is ReviewActionErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<ReviewsBloc, ReviewsState>(
          buildWhen: (previous, current) => current is ReviewsLoadedState || current is ReviewsLoadingState || current is ReviewsErrorState,
          builder: (context, state) {
            if (state is ReviewsLoadingState || state is ReviewsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReviewsErrorState) {
              return Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)));
            }

            if (state is ReviewsLoadedState) {
              final reviews = state.reviewsData.reviews;
              if (reviews.isEmpty) {
                 return const Center(child: Text("No reviews yet.", style: TextStyle(color: Colors.grey)));
              }
              
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final overallRatingDouble = double.tryParse(review.overallRating) ?? 0.0;
                  
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: List.generate(5, (sIndex) {
                                return Icon(
                                  Icons.star,
                                  size: 20,
                                  color: sIndex < overallRatingDouble.round()
                                      ? Colors.green[700]
                                      : Colors.grey[300],
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            if (review.overallRating.isNotEmpty && overallRatingDouble > 0)
                              Text(
                                review.overallRating,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            if (review.reviewTitle.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "•",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  review.reviewTitle,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        
                        if (review.customerName.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "By ${review.customerName}",
                              style: TextStyle(color: Colors.grey[400], fontSize: 13),
                            ),
                          ),
                        
                        const SizedBox(height: 8),

                        Text(
                          review.reviewText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
