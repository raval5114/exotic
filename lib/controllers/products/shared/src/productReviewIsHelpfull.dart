import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/reviews/reviews_bloc.dart';
import 'package:exotic/data/models/reviews.dart';

class Productreviewishelpfull extends StatefulWidget {
  final Review review;
  const Productreviewishelpfull({super.key, required this.review});

  @override
  State<Productreviewishelpfull> createState() =>
      _ProductreviewishelpfullState();
}

class _ProductreviewishelpfullState extends State<Productreviewishelpfull> {
  int? _vote; // 1 for helpful, -1 for not helpful

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final isHelpful = _vote == 1;
    final isNotHelpful = _vote == -1;

    final primaryColor = Theme.of(context).primaryColor;

    final helpfulColor = isHelpful ? primaryColor : Colors.grey[700];
    final helpfulBg =
        isHelpful ? primaryColor.withOpacity(0.1) : Colors.transparent;
    final helpfulBorder = isHelpful ? primaryColor : Colors.grey[300]!;

    final notHelpfulColor = isNotHelpful ? Colors.red : Colors.grey[700];
    final notHelpfulBg =
        isNotHelpful ? Colors.red.withOpacity(0.1) : Colors.transparent;
    final notHelpfulBorder = isNotHelpful ? Colors.red : Colors.grey[300]!;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Text(
            "Helpful?",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isHelpful) return; // Already voted helpful
                setState(() {
                  _vote = 1;
                });
                context.read<ReviewsBloc>().add(
                  ChangeReviewHelpfulEvent(review.reviewId, true),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: helpfulBg,
                  border: Border.all(color: helpfulBorder),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      isHelpful
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt_outlined,
                      size: 14,
                      color: helpfulColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      (review.helpfulCount + (isHelpful ? 1 : 0)).toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: helpfulColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isNotHelpful) return; // Already voted not helpful
                setState(() {
                  _vote = -1;
                });
                context.read<ReviewsBloc>().add(
                  ChangeReviewHelpfulEvent(review.reviewId, false),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: notHelpfulBg,
                  border: Border.all(color: notHelpfulBorder),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      isNotHelpful
                          ? Icons.thumb_down_alt
                          : Icons.thumb_down_alt_outlined,
                      size: 14,
                      color: notHelpfulColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      (review.notHelpfulCount + (isNotHelpful ? 1 : 0))
                          .toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: notHelpfulColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
