import 'package:exotic/controllers/Reviews/reviewsController.dart';
import 'package:exotic/data/providers/reviews_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/reviews/reviews_bloc.dart';

class ReviewScreen extends StatelessWidget {
  final ReviewsProvider reviewsProvider;

  const ReviewScreen({super.key, required this.reviewsProvider});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewsBloc(),
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
        body: ReviewsBody(reviewsProvider: reviewsProvider),
      ),
    );
  }
}
