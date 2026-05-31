import 'dart:convert';
import 'package:http/http.dart' as http;

class AdService {
  // Production domain URL for exotic ads API
  static const String baseUrl = 'https://xotic.in/api/ads';

  /// 1. Fetch Ads Placement
  /// Automatically logs impressions for every returned ad in the backend!
  ///
  /// [page] - homepage, category, product, search, cart, checkout
  /// [position] - top, middle, bottom, sidebar
  static Future<Map<String, dynamic>?> fetchAdPlacement({
    required String page,
    required String position,
    int? userId,
    int? categoryId,
    String? keyword,
    int limit = 3,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'position': position,
        if (userId != null) 'user_id': userId.toString(),
        if (categoryId != null) 'category_id': categoryId.toString(),
        if (keyword != null) 'keyword': keyword,
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/get_placements.php').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          return decoded['data'];
        }
      }
    } catch (e) {
      print('AdService.fetchAdPlacement Error: $e');
    }

    // premium visual mock fallback mode for local testing
    if (page == 'homepage') {
      if (position == 'top') {
        return {
          'placement': {
            'id': 1,
            'vc_name': 'Premium Brands',
            'ad_type': 'promote_brand'
          },
          'ads': [
            {
              'campaign_id': 42,
              'banner_id': 10,
              'cb_banner_url': 'https://xotic.in',
              'banner_image_url': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&auto=format&fit=crop',
              'vc_campaign_name': 'Summer Luxury Fashion'
            }
          ]
        };
      } else if (position == 'middle') {
        return {
          'placement': {
            'id': 2,
            'vc_name': 'Trending Merchant Highlights',
            'ad_type': 'promote_product'
          },
          'ads': [
            {
              'campaign_id': 43,
              'product_id': 12, // valid ID from database or mock
              'product_image_url': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&auto=format&fit=crop',
              'product_name': 'AeroSport Pro Running Shoes',
              'selling_price': 1899,
              'mrp': 2999
            },
            {
              'campaign_id': 44,
              'product_id': 13,
              'product_image_url': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop',
              'product_name': 'Vanguard Chronograph Watch',
              'selling_price': 3499,
              'mrp': 4999
            }
          ]
        };
      } else if (position == 'bottom') {
        return {
          'placement': {
            'id': 3,
            'vc_name': 'Handpicked Sponsored Offers',
            'ad_type': 'promote_product'
          },
          'ads': [
            {
              'campaign_id': 45,
              'product_id': 14,
              'product_image_url': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400&auto=format&fit=crop',
              'product_name': 'Retro Horizon Sunglasses',
              'selling_price': 999,
              'mrp': 1599
            }
          ]
        };
      }
    }
    return null;
  }

  /// 2. Track Click
  /// Deducts CPC from vendor wallet, records click logs, and guards against fraud duplicates.
  ///
  /// [campaignId] - VC ID from the placement response
  /// [adType] - Must be: 'search' | 'product_grid' | 'banner'
  static Future<Map<String, dynamic>?> trackClick({
    required int campaignId,
    required String adType,
    int? productId,
    int? bannerId,
    int? placementId,
    int? userId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/track_click.php');
      final body = {
        'campaign_id': campaignId,
        'ad_type': adType,
        if (productId != null) 'product_id': productId,
        if (bannerId != null) 'banner_id': bannerId,
        if (placementId != null) 'placement_id': placementId,
        if (userId != null) 'user_id': userId,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == true) {
          return decoded;
        }
      }
    } catch (e) {
      print('AdService.trackClick Error: $e');
    }
    return null;
  }

  /// 3. Track Conversion (ROI Reporting)
  /// Triggers on successful checkouts. Links placed orders to the campaigns they clicked.
  ///
  /// [campaignId] - Saved campaign_id from the user's click interaction
  /// [orderId] - Database order ID of the purchase
  /// [clickId] - Saved click_id returned from the trackClick response
  static Future<bool> trackConversion({
    required int campaignId,
    required int orderId,
    int? userId,
    int? clickId,
    int? productId,
    double? conversionValue,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/track_conversion.php');
      final body = {
        'campaign_id': campaignId,
        'order_id': orderId,
        if (userId != null) 'user_id': userId,
        if (clickId != null) 'click_id': clickId,
        if (productId != null) 'product_id': productId,
        if (conversionValue != null) 'conversion_value': conversionValue,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['status'] == true;
      }
    } catch (e) {
      print('AdService.trackConversion Error: $e');
    }
    return false;
  }
}
