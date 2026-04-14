part of 'reviews_bloc.dart';

abstract class ReviewsEvent {}

class FetchReviewsEvent extends ReviewsEvent {
  final int productId;
  FetchReviewsEvent(this.productId);
}

class AddReviewEvent extends ReviewsEvent {
  final int productId;
  final Map<String, dynamic> reviewData;
  AddReviewEvent(this.productId, this.reviewData);
}

class UpdateReviewEvent extends ReviewsEvent {
  final int reviewId;
  final Map<String, dynamic> reviewData;
  UpdateReviewEvent(this.reviewId, this.reviewData);
}

class DeleteReviewEvent extends ReviewsEvent {
  final int reviewId;
  DeleteReviewEvent(this.reviewId);
}
