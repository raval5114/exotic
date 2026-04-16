part of 'reviews_bloc.dart';

abstract class ReviewsEvent {}

class FetchReviewsEvent extends ReviewsEvent {
  final int productId;
  FetchReviewsEvent(this.productId);
}

class AddReviewEvent extends ReviewsEvent {
  final String customerId;
  final int productId;
  final double overallRating;
  final double qualityRating;
  final double valueRating;
  final double deliveryRating;
  final String reviewTitle;
  final String reviewText;
  final String pros;
  final String cons;
  final int orderId;
  final int orderItemId;

  AddReviewEvent(
    this.customerId,
    this.productId,
    this.overallRating,
    this.qualityRating,
    this.valueRating,
    this.deliveryRating,
    this.reviewTitle,
    this.reviewText,
    this.pros,
    this.cons,
    this.orderId,
    this.orderItemId,
  );
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
