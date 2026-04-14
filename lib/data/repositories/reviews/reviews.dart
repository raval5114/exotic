abstract class IReviewsRepo {
  Future<Map<String, dynamic>> getReviews(int productId);
  Future<Map<String, dynamic>> addReview(
    int productId,
    Map<String, dynamic> review,
  );
  Future<Map<String, dynamic>> updateReview(
    int reviewId,
    Map<String, dynamic> review,
  );
  Future<Map<String, dynamic>> deleteReview(int reviewId);
}
