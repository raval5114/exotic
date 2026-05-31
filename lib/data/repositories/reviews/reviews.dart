abstract class IReviewsRepo {
  Future<Map<String, dynamic>> getReviews(int productId);
  Future<Map<String, dynamic>> addReview(
    String customerId,
    int productId,
    double overallRating,
    double qualityRating,
    double valueRating,
    double deliveryRating,
    String reviewTitle,
    String reviewText,
    String pros,
    String cons,
    int orderId,
    int orderItemId,
  );
  Future<Map<String, dynamic>> updateReview(
    int reviewId,
    Map<String, dynamic> review,
  );
  Future<Map<String, dynamic>> deleteReview(int reviewId);
  Future<Map<String, dynamic>> isHelpfull({
    required int reviewId,
    required bool isHelpfull,
  });
}
