class ReviewsModel {
  final ReviewsData data;
  final String timestamp;

  ReviewsModel({required this.data, required this.timestamp});

  factory ReviewsModel.fromJson(Map<String, dynamic> json) {
    return ReviewsModel(
      data: ReviewsData.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }
}

class ReviewsData {
  final List<Review> reviews;
  final ReviewSummary summary;
  final ReviewPagination pagination;
  final FiltersApplied filtersApplied;

  ReviewsData({
    required this.reviews,
    required this.summary,
    required this.pagination,
    required this.filtersApplied,
  });

  factory ReviewsData.fromJson(Map<String, dynamic> json) {
    return ReviewsData(
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      summary: ReviewSummary.fromJson(json['summary'] ?? {}),
      pagination: ReviewPagination.fromJson(json['pagination'] ?? {}),
      filtersApplied: FiltersApplied.fromJson(json['filters_applied'] ?? {}),
    );
  }
}

class Review {
  final int reviewId;
  final int productId;
  final int customerId;
  final int orderId;
  final int? orderItemId;
  final int vendorId;
  final String overallRating;
  final String qualityRating;
  final String valueRating;
  final String deliveryRating;
  final String reviewTitle;
  final String reviewText;
  final String pros;
  final String cons;
  final List<String> reviewImages;
  final List<String> reviewVideos;
  final int isVerifiedPurchase;
  final int isApproved;
  final int isFeatured;
  final String status;
  final int helpfulCount;
  final int notHelpfulCount;
  final int reportCount;
  final String? vendorResponse;
  final String? vendorResponseDate;
  final String createdAt;
  final String updatedAt;
  final String customerName;
  final String customerEmail;
  final String createdAtFormatted;
  final int daysAgo;

  Review({
    required this.reviewId,
    required this.productId,
    required this.customerId,
    required this.orderId,
    this.orderItemId,
    required this.vendorId,
    required this.overallRating,
    required this.qualityRating,
    required this.valueRating,
    required this.deliveryRating,
    required this.reviewTitle,
    required this.reviewText,
    required this.pros,
    required this.cons,
    required this.reviewImages,
    required this.reviewVideos,
    required this.isVerifiedPurchase,
    required this.isApproved,
    required this.isFeatured,
    required this.status,
    required this.helpfulCount,
    required this.notHelpfulCount,
    required this.reportCount,
    this.vendorResponse,
    this.vendorResponseDate,
    required this.createdAt,
    required this.updatedAt,
    required this.customerName,
    required this.customerEmail,
    required this.createdAtFormatted,
    required this.daysAgo,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: (json['review_id'] as num?)?.toInt() ?? 0,
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      customerId: (json['customer_id'] as num?)?.toInt() ?? 0,
      orderId: (json['order_id'] as num?)?.toInt() ?? 0,
      orderItemId: (json['order_item_id'] as num?)?.toInt(),
      vendorId: (json['vendor_id'] as num?)?.toInt() ?? 0,
      overallRating: json['overall_rating']?.toString() ?? '',
      qualityRating: json['quality_rating']?.toString() ?? '',
      valueRating: json['value_rating']?.toString() ?? '',
      deliveryRating: json['delivery_rating']?.toString() ?? '',
      reviewTitle: json['review_title']?.toString() ?? '',
      reviewText: json['review_text']?.toString() ?? '',
      pros: json['pros']?.toString() ?? '',
      cons: json['cons']?.toString() ?? '',
      reviewImages:
          (json['review_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      reviewVideos:
          (json['review_videos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isVerifiedPurchase: (json['is_verified_purchase'] as num?)?.toInt() ?? 0,
      isApproved: (json['is_approved'] as num?)?.toInt() ?? 0,
      isFeatured: (json['is_featured'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,
      notHelpfulCount: (json['not_helpful_count'] as num?)?.toInt() ?? 0,
      reportCount: (json['report_count'] as num?)?.toInt() ?? 0,
      vendorResponse: json['vendor_response']?.toString(),
      vendorResponseDate: json['vendor_response_date']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerEmail: json['customer_email']?.toString() ?? '',
      createdAtFormatted: json['created_at_formatted']?.toString() ?? '',
      daysAgo: (json['days_ago'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReviewSummary {
  final int productId;
  final int totalReviews;
  final String averageRating;
  final String averageQuality;
  final String averageValue;
  final String averageDelivery;
  final int rating5Count;
  final int rating4Count;
  final int rating3Count;
  final int rating2Count;
  final int rating1Count;
  final int verifiedPurchaseCount;
  final int withImagesCount;
  final String lastUpdated;

  ReviewSummary({
    required this.productId,
    required this.totalReviews,
    required this.averageRating,
    required this.averageQuality,
    required this.averageValue,
    required this.averageDelivery,
    required this.rating5Count,
    required this.rating4Count,
    required this.rating3Count,
    required this.rating2Count,
    required this.rating1Count,
    required this.verifiedPurchaseCount,
    required this.withImagesCount,
    required this.lastUpdated,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      averageRating: json['average_rating']?.toString() ?? '',
      averageQuality: json['average_quality']?.toString() ?? '',
      averageValue: json['average_value']?.toString() ?? '',
      averageDelivery: json['average_delivery']?.toString() ?? '',
      rating5Count: (json['rating_5_count'] as num?)?.toInt() ?? 0,
      rating4Count: (json['rating_4_count'] as num?)?.toInt() ?? 0,
      rating3Count: (json['rating_3_count'] as num?)?.toInt() ?? 0,
      rating2Count: (json['rating_2_count'] as num?)?.toInt() ?? 0,
      rating1Count: (json['rating_1_count'] as num?)?.toInt() ?? 0,
      verifiedPurchaseCount:
          (json['verified_purchase_count'] as num?)?.toInt() ?? 0,
      withImagesCount: (json['with_images_count'] as num?)?.toInt() ?? 0,
      lastUpdated: json['last_updated']?.toString() ?? '',
    );
  }
}

class ReviewPagination {
  final int currentPage;
  final int totalPages;
  final int totalReviews;
  final int perPage;
  final bool hasNext;
  final bool hasPrev;

  ReviewPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalReviews,
    required this.perPage,
    required this.hasNext,
    required this.hasPrev,
  });

  factory ReviewPagination.fromJson(Map<String, dynamic> json) {
    return ReviewPagination(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      perPage: (json['per_page'] as num?)?.toInt() ?? 0,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrev: json['has_prev'] as bool? ?? false,
    );
  }
}

class FiltersApplied {
  final String sort;
  final String filter;

  FiltersApplied({required this.sort, required this.filter});

  factory FiltersApplied.fromJson(Map<String, dynamic> json) {
    return FiltersApplied(
      sort: json['sort']?.toString() ?? '',
      filter: json['filter']?.toString() ?? '',
    );
  }
}
