import 'dart:convert';
import 'package:exotic/data/repositories/reviews/reviews.dart';
import 'package:http/http.dart' as http;

class Reviews extends IReviewsRepo {
  static const String _baseUrl = "https://xotic.in/api/reviews/";
  @override
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
  ) async {
    final Map<String, dynamic> requestBody = {
      "customer_id": customerId,
      "product_id": productId,
      "overall_rating": overallRating,
      "quality_rating": qualityRating,
      "value_rating": valueRating,
      "delivery_rating": deliveryRating,
      "review_title": reviewTitle,
      "review_text": reviewText,
      "pros": pros,
      "cons": cons,
      "order_id": orderId,
      "order_item_id": orderItemId,
    };

    final response = await http.post(
      Uri.parse("https://xotic.in/api/reviews-mobile/create.php"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> deleteReview(int reviewId) {
    // TODO: implement deleteReview
    throw UnimplementedError();
  }

  Map<String, dynamic> _mockReviewsResponse() {
    return {
      "success": true,
      "message": "Reviews retrieved successfully",
      "data": {
        "reviews": [
          {
            "review_id": 1,
            "product_id": 60,
            "customer_id": 7,
            "order_id": 0,
            "order_item_id": null,
            "vendor_id": 7,
            "overall_rating": "5.0",
            "quality_rating": "5.0",
            "value_rating": "5.0",
            "delivery_rating": "5.0",
            "review_title": "Absolutely fantastic!",
            "review_text":
                "I was hesitant at first, but this product exceeded all my expectations. The build quality feels very premium, and it fits perfectly in my bathroom. Delivery was incredibly fast, arriving a day ahead of schedule.",
            "pros": "Great build quality\r\nFast delivery\r\nLooks premium",
            "cons": "",
            "review_images": [],
            "review_videos": [],
            "is_verified_purchase": 1,
            "is_approved": 1,
            "is_featured": 1,
            "status": "approved",
            "helpful_count": 12,
            "not_helpful_count": 0,
            "report_count": 0,
            "vendor_response":
                "Thank you so much for your wonderful feedback! We are thrilled you love it.",
            "vendor_response_date": "2026-04-15 11:20:00",
            "created_at": "2026-04-15 09:12:16",
            "updated_at": "2026-04-15 09:12:16",
            "customer_name": "Sarah Jenkins",
            "customer_email": "sar***@gmail.com",
            "created_at_formatted": "Apr 15, 2026",
            "days_ago": 0,
          },
          {
            "review_id": 2,
            "product_id": 60,
            "customer_id": 14,
            "order_id": 0,
            "order_item_id": null,
            "vendor_id": 7,
            "overall_rating": "4.0",
            "quality_rating": "4.0",
            "value_rating": "5.0",
            "delivery_rating": "4.0",
            "review_title": "Worth buying for bathroom organization",
            "review_text":
                "I recently purchased this wall mount bathroom shelf set, and overall I am quite satisfied with the product. The quality is good for the price, and the material feels sturdy enough to hold daily essentials like soap, shampoo, and small bottles.\r\n\r\nThe only minor drawback is that the finish could be slightly better, but it does not affect functionality.",
            "pros":
                "Easy to install\r\nGood value for money\r\nLightweight yet sturdy",
            "cons": "Finishing could be improved slightly",
            "review_images": [],
            "review_videos": [],
            "is_verified_purchase": 1,
            "is_approved": 1,
            "is_featured": 0,
            "status": "approved",
            "helpful_count": 3,
            "not_helpful_count": 1,
            "report_count": 0,
            "vendor_response": null,
            "vendor_response_date": null,
            "created_at": "2026-04-14 10:12:16",
            "updated_at": "2026-04-14 10:12:16",
            "customer_name": "swiftica infoway",
            "customer_email": "swi***@gmail.com",
            "created_at_formatted": "Apr 14, 2026",
            "days_ago": 1,
          },
          {
            "review_id": 3,
            "product_id": 60,
            "customer_id": 21,
            "order_id": 0,
            "order_item_id": null,
            "vendor_id": 7,
            "overall_rating": "3.0",
            "quality_rating": "3.0",
            "value_rating": "3.0",
            "delivery_rating": "4.0",
            "review_title": "It's okay, does the job",
            "review_text":
                "Average product. It works fine for holding a few lightweight items, but I wouldn't trust it with heavier glass bottles. The adhesive pads it came with were a bit difficult to stick perfectly straight.",
            "pros": "Functional",
            "cons": "Adhesive could be stronger\r\nNot for heavy items",
            "review_images": [],
            "review_videos": [],
            "is_verified_purchase": 1,
            "is_approved": 1,
            "is_featured": 0,
            "status": "approved",
            "helpful_count": 0,
            "not_helpful_count": 0,
            "report_count": 0,
            "vendor_response": null,
            "vendor_response_date": null,
            "created_at": "2026-04-10 14:45:00",
            "updated_at": "2026-04-10 14:45:00",
            "customer_name": "Michael R.",
            "customer_email": "mic***@yahoo.com",
            "created_at_formatted": "Apr 10, 2026",
            "days_ago": 5,
          },
          {
            "review_id": 4,
            "product_id": 60,
            "customer_id": 8,
            "order_id": 0,
            "order_item_id": null,
            "vendor_id": 7,
            "overall_rating": "5.0",
            "quality_rating": "5.0",
            "value_rating": "5.0",
            "delivery_rating": "5.0",
            "review_title": "Super convenient",
            "review_text":
                "Really happy with this purchase. It totally transformed my bathroom space. I can easily reach all my skincare products now.",
            "pros": "Saves space\r\nVery attractive design",
            "cons": "",
            "review_images": [],
            "review_videos": [],
            "is_verified_purchase": 0,
            "is_approved": 1,
            "is_featured": 0,
            "status": "approved",
            "helpful_count": 1,
            "not_helpful_count": 0,
            "report_count": 0,
            "vendor_response": null,
            "vendor_response_date": null,
            "created_at": "2026-04-05 18:30:22",
            "updated_at": "2026-04-05 18:30:22",
            "customer_name": "anonymous customer",
            "customer_email": "ano***@outlook.com",
            "created_at_formatted": "Apr 05, 2026",
            "days_ago": 10,
          },
          {
            "review_id": 5,
            "product_id": 60,
            "customer_id": 33,
            "order_id": 0,
            "order_item_id": null,
            "vendor_id": 7,
            "overall_rating": "2.0",
            "quality_rating": "2.0",
            "value_rating": "2.0",
            "delivery_rating": "1.0",
            "review_title": "Disappointed with delivery",
            "review_text":
                "The box arrived completely crushed. The shelf itself had a minor scratch on the corner. It's usable so I won't return it, but the packaging needs serious improvement.",
            "pros": "",
            "cons": "Poor packaging\r\nArrived damaged",
            "review_images": [],
            "review_videos": [],
            "is_verified_purchase": 1,
            "is_approved": 1,
            "is_featured": 0,
            "status": "approved",
            "helpful_count": 4,
            "not_helpful_count": 2,
            "report_count": 0,
            "vendor_response": null,
            "vendor_response_date": null,
            "created_at": "2026-03-29 08:15:10",
            "updated_at": "2026-03-29 08:15:10",
            "customer_name": "David W.",
            "customer_email": "dav***@hotmail.com",
            "created_at_formatted": "Mar 29, 2026",
            "days_ago": 17,
          },
        ],
        "summary": {
          "product_id": 60,
          "total_reviews": 5,
          "average_rating": "3.80",
          "average_quality": "3.80",
          "average_value": "4.00",
          "average_delivery": "3.80",
          "rating_5_count": 2,
          "rating_4_count": 1,
          "rating_3_count": 1,
          "rating_2_count": 1,
          "rating_1_count": 0,
          "verified_purchase_count": 4,
          "with_images_count": 0,
          "last_updated": "2026-04-15 12:00:00",
        },
        "pagination": {
          "current_page": 1,
          "total_pages": 1,
          "total_reviews": 5,
          "per_page": 10,
          "has_next": false,
          "has_prev": false,
        },
        "filters_applied": {"sort": "recent", "filter": "all"},
      },
      "timestamp": "2026-04-15 12:00:01",
    };
  }

  @override
  Future<Map<String, dynamic>> getReviews(int productId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final responseBody = await http.get(
      Uri.parse("${_baseUrl}get.php?product_id=$productId"),
    );
    // Returning the 'data' field directly exactly as previously structured
    return jsonDecode(responseBody.body) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateReview(
    int reviewId,
    Map<String, dynamic> review,
  ) async {
    // Shallow implementation to mock success response for update
    await Future.delayed(const Duration(seconds: 1));
    return {"success": true, "message": "Review updated successfully!"};
  }

  @override 
  Future<Map<String, dynamic>> isHelpfull({
    required int reviewId,
    required bool isHelpfull,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${_baseUrl}helpful.php"),
        body: {
          "review_id": reviewId.toString(),
          "is_helpful": isHelpfull ? "1" : "0",
        },
      );
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {"error": e.toString(), "success": false};
    }
  }
}
