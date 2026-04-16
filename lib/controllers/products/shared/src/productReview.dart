class ProductReview {
  final double rating;
  final String reviewText;
  final String? sizeInfo;
  final String qualityText;

  ProductReview({
    required this.rating,
    required this.reviewText,
    this.sizeInfo,
    required this.qualityText,
  });
}
