import 'package:flutter/material.dart';
import 'package:exotic/data/models/reviews.dart';

class ReviewsProvider extends ChangeNotifier {
  ReviewsData? _reviewsData;

  ReviewsData? get reviewsData => _reviewsData;

  void setReviewsData(ReviewsData? data) {
    _reviewsData = data;
    notifyListeners();
  }

  void addReview(Review review) {
    if (_reviewsData != null) {
      _reviewsData!.reviews.insert(0, review);
      notifyListeners();
    }
  }

  void updateReview(Review review) {
    if (_reviewsData != null) {
      final index = _reviewsData!.reviews.indexWhere((r) => r.reviewId == review.reviewId);
      if (index != -1) {
        _reviewsData!.reviews[index] = review;
        notifyListeners();
      }
    }
  }

  void deleteReview(int reviewId) {
    if (_reviewsData != null) {
      _reviewsData!.reviews.removeWhere((r) => r.reviewId == reviewId);
      notifyListeners();
    }
  }
}
