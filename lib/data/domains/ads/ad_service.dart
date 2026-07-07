import 'dart:convert';
import 'package:exotic/data/repositories/ads/ad_repo.dart';
import 'package:http/http.dart' as http;

class AdService extends AdRepo {
  // Production domain URL for exotic ads API
  static const String baseUrl = 'https://xotic.in/api/ads';

  /// 1. Fetch Ads Placement
  /// Automatically logs impressions for every returned ad in the backend!
  ///
  /// [page] - homepage, category, product, search, cart, checkout
  /// [position] - top, middle, bottom, sidebar
  @override
  Future<Map<String, dynamic>?> fetchAdPlacement({
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

      final uri = Uri.parse(
        '$baseUrl/get_placements.php',
      ).replace(queryParameters: queryParams);
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
    if (_mockData.containsKey(page) && _mockData[page]!.containsKey(position)) {
      return _mockData[page]![position];
    }

    return null;
  }

  /// 2. Track Click
  /// Deducts CPC from vendor wallet, records click logs, and guards against fraud duplicates.
  ///
  /// [campaignId] - VC ID from the placement response
  /// [adType] - Must be: 'search' | 'product_grid' | 'banner'
  @override
  Future<Map<String, dynamic>?> trackClick({
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
  @override
  Future<bool> trackConversion({
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

  // Premium mock database structure containing fallback ads for local preview
  static final Map<String, Map<String, Map<String, dynamic>>> _mockData = {
    'homepage': {
      'top': {
        'placement': {
          'id': 1,
          'vc_name': 'Premium Brands',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 42,
            'banner_id': 10,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Summer Luxury Fashion',
          },
        ],
      },
      'middle': {
        'placement': {
          'id': 2,
          'vc_name': 'Trending Merchant Highlights',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 43,
            'product_id': 12,
            'product_image_url':
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&auto=format&fit=crop',
            'product_name': 'AeroSport Pro Running Shoes',
            'selling_price': 1899,
            'mrp': 2999,
          },
          {
            'campaign_id': 44,
            'product_id': 13,
            'product_image_url':
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop',
            'product_name': 'Vanguard Chronograph Watch',
            'selling_price': 3499,
            'mrp': 4999,
          },
        ],
      },
      'bottom': {
        'placement': {
          'id': 3,
          'vc_name': 'Handpicked Sponsored Offers',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 45,
            'product_id': 14,
            'product_image_url':
                'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400&auto=format&fit=crop',
            'product_name': 'Retro Horizon Sunglasses',
            'selling_price': 999,
            'mrp': 1599,
          },
        ],
      },
      'sidebar': {
        'placement': {
          'id': 4,
          'vc_name': 'Exclusive VIP Club',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 46,
            'banner_id': 11,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'VIP Lounge Perks',
          },
        ],
      },
    },
    'category': {
      'top': {
        'placement': {
          'id': 5,
          'vc_name': 'Premium Collection Highlights',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 47,
            'banner_id': 12,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Explore Luxury Trends',
          },
        ],
      },
      'middle': {
        'placement': {
          'id': 6,
          'vc_name': 'Featured Category Products',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 48,
            'product_id': 15,
            'product_image_url':
                'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&auto=format&fit=crop',
            'product_name': 'Elegance Leather Handbag',
            'selling_price': 2499,
            'mrp': 3999,
          },
          {
            'campaign_id': 49,
            'product_id': 16,
            'product_image_url':
                'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400&auto=format&fit=crop',
            'product_name': 'Velvet Matte Lipstick Set',
            'selling_price': 799,
            'mrp': 1200,
          },
        ],
      },
      'bottom': {
        'placement': {
          'id': 7,
          'vc_name': 'Deals of the Week',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 50,
            'product_id': 17,
            'product_image_url':
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&auto=format&fit=crop',
            'product_name': 'Wireless Noise-Cancelling Earbuds',
            'selling_price': 1599,
            'mrp': 2499,
          },
          {
            'campaign_id': 51,
            'product_id': 18,
            'product_image_url':
                'https://images.unsplash.com/photo-1505797149-43b0069ec26b?w=400&auto=format&fit=crop',
            'product_name': 'Ergonomic Office Chair',
            'selling_price': 4999,
            'mrp': 8999,
          },
        ],
      },
      'sidebar': {
        'placement': {
          'id': 8,
          'vc_name': 'Curated For You',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 52,
            'banner_id': 13,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Chic Wardrobe Upgrades',
          },
        ],
      },
    },
    'product': {
      'top': {
        'placement': {
          'id': 9,
          'vc_name': 'Sponsored Recommendations',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 53,
            'product_id': 19,
            'product_image_url':
                'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=400&auto=format&fit=crop',
            'product_name': 'SMARTRIX Pack of 2 Men Solid Round Neck T-Shirt',
            'selling_price': 315,
            'mrp': 1499,
          },
          {
            'campaign_id': 531,
            'product_id': 20,
            'product_image_url':
                'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400&auto=format&fit=crop',
            'product_name': 'Roadster Cotton Solid Round Neck T-Shirt',
            'selling_price': 299,
            'mrp': 999,
          },
        ],
      },
      'middle': {
        'placement': {
          'id': 10,
          'vc_name': 'Customers Also Viewed',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 54,
            'product_id': 19,
            'product_image_url':
                'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?w=400&auto=format&fit=crop',
            'product_name': 'Minimalist Quartz Watch',
            'selling_price': 1999,
            'mrp': 2999,
          },
          {
            'campaign_id': 55,
            'product_id': 20,
            'product_image_url':
                'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400&auto=format&fit=crop',
            'product_name': 'Smart Fitness Tracker',
            'selling_price': 1299,
            'mrp': 1999,
          },
        ],
      },
      'bottom': {
        'placement': {
          'id': 11,
          'vc_name': 'Frequently Bought Together',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 56,
            'product_id': 21,
            'product_image_url':
                'https://images.unsplash.com/photo-1627124765135-56a5181732e4?w=400&auto=format&fit=crop',
            'product_name': 'Leather Bi-Fold Wallet',
            'selling_price': 899,
            'mrp': 1499,
          },
          {
            'campaign_id': 57,
            'product_id': 22,
            'product_image_url':
                'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400&auto=format&fit=crop',
            'product_name': 'Aviator Metal Sunglasses',
            'selling_price': 1199,
            'mrp': 1999,
          },
        ],
      },
      'sidebar': {
        'placement': {
          'id': 12,
          'vc_name': 'Accessorize Your Style',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 58,
            'banner_id': 15,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Complete The Look',
          },
        ],
      },
    },
    'search': {
      'top': {
        'placement': {
          'id': 13,
          'vc_name': 'Sponsored Top Picks',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 59,
            'product_id': 23,
            'product_image_url':
                'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&auto=format&fit=crop',
            'product_name': 'Ultra-Lightweight Running Jacket',
            'selling_price': 1499,
            'mrp': 2499,
          },
          {
            'campaign_id': 60,
            'product_id': 24,
            'product_image_url':
                'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&auto=format&fit=crop',
            'product_name': 'Titanium Sports Water Bottle',
            'selling_price': 599,
            'mrp': 999,
          },
        ],
      },
      'middle': {
        'placement': {
          'id': 14,
          'vc_name': 'Recommended For Search',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 61,
            'product_id': 25,
            'product_image_url':
                'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&auto=format&fit=crop',
            'product_name': 'Dual-Driver Bluetooth Earphones',
            'selling_price': 999,
            'mrp': 1799,
          },
        ],
      },
      'bottom': {
        'placement': {
          'id': 15,
          'vc_name': 'Brand Spotlight',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 62,
            'banner_id': 16,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Step Into Style: Nike Special',
          },
        ],
      },
      'sidebar': {
        'placement': {
          'id': 16,
          'vc_name': 'Trending Keywords Showcase',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 63,
            'product_id': 26,
            'product_image_url':
                'https://images.unsplash.com/photo-1544816155-12df9643f363?w=400&auto=format&fit=crop',
            'product_name': 'Canvas Crossbody Bag',
            'selling_price': 799,
            'mrp': 1299,
          },
        ],
      },
    },
    'cart': {
      'top': {
        'placement': {
          'id': 17,
          'vc_name': 'Unlock Free Shipping Offer',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 64,
            'banner_id': 17,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Add ₹500 more for Free VIP Shipping',
          },
        ],
      },
      'middle': {
        'placement': {
          'id': 18,
          'vc_name': "Don't Forget These Accessories",
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 65,
            'product_id': 27,
            'product_image_url':
                'https://images.unsplash.com/photo-1585336139058-9c74f5b40884?w=400&auto=format&fit=crop',
            'product_name': 'Microfiber Screen Cleaner',
            'selling_price': 199,
            'mrp': 399,
          },
          {
            'campaign_id': 66,
            'product_id': 28,
            'product_image_url':
                'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400&auto=format&fit=crop',
            'product_name': 'Universal Travel Adapter',
            'selling_price': 499,
            'mrp': 899,
          },
        ],
      },
      'bottom': {
        'placement': {
          'id': 19,
          'vc_name': 'Last Minute Deals',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 67,
            'product_id': 29,
            'product_image_url':
                'https://images.unsplash.com/photo-1582966772680-860e372bb558?w=400&auto=format&fit=crop',
            'product_name': 'Premium Quality Socks (Pack of 3)',
            'selling_price': 299,
            'mrp': 499,
          },
        ],
      },
      'sidebar': {
        'placement': {
          'id': 20,
          'vc_name': 'Quick Checkout Discount',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 68,
            'banner_id': 18,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Extra 5% off with Gold Card',
          },
        ],
      },
    },
    'checkout': {
      'top': {
        'placement': {
          'id': 21,
          'vc_name': 'Secure Shipping Upgrades',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 69,
            'banner_id': 19,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Upgrade to Next-Day Delivery',
          },
        ],
      },
      'middle': {
        'placement': {
          'id': 22,
          'vc_name': 'Last Chance Offers',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 70,
            'product_id': 30,
            'product_image_url':
                'https://images.unsplash.com/photo-1532453242-14300979b98f?w=400&auto=format&fit=crop',
            'product_name': 'Eco-Friendly Reusable Bag',
            'selling_price': 99,
            'mrp': 199,
          },
          {
            'campaign_id': 71,
            'product_id': 31,
            'product_image_url':
                'https://images.unsplash.com/photo-1544816155-12df9643f363?w=400&auto=format&fit=crop',
            'product_name': 'Premium Gift Wrapping Service',
            'selling_price': 150,
            'mrp': 250,
          },
        ],
      },
      'bottom': {
        'placement': {
          'id': 23,
          'vc_name': 'Sponsored Post-Purchase Preview',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 72,
            'product_id': 32,
            'product_image_url':
                'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&auto=format&fit=crop',
            'product_name': 'Exclusive Extended Warranty Card',
            'selling_price': 399,
            'mrp': 799,
          },
        ],
      },
      'sidebar': {
        'placement': {
          'id': 24,
          'vc_name': 'Loyalty Rewards Club',
          'ad_type': 'promote_brand',
        },
        'ads': [
          {
            'campaign_id': 73,
            'banner_id': 20,
            'cb_banner_url': 'https://xotic.in',
            'banner_image_url':
                'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=800&auto=format&fit=crop',
            'vc_campaign_name': 'Earn Double Points Today',
          },
        ],
      },
    },

    // ── product-grid page: inline 2-column sponsored grid ──────────────────
    'product-grid': {
      'top': {
        'placement': {
          'id': 25,
          'vc_name': 'Top Sponsored Picks',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 74,
            'product_id': 33,
            'product_image_url':
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&auto=format&fit=crop',
            'product_name': 'AeroSport Pro Running Shoes',
            'selling_price': 1899,
            'mrp': 2999,
          },
          {
            'campaign_id': 75,
            'product_id': 34,
            'product_image_url':
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop',
            'product_name': 'Vanguard Chronograph Watch',
            'selling_price': 3499,
            'mrp': 4999,
          },
          {
            'campaign_id': 76,
            'product_id': 35,
            'product_image_url':
                'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400&auto=format&fit=crop',
            'product_name': 'Retro Horizon Sunglasses',
            'selling_price': 999,
            'mrp': 1599,
          },
          {
            'campaign_id': 77,
            'product_id': 36,
            'product_image_url':
                'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&auto=format&fit=crop',
            'product_name': 'Elegance Leather Handbag',
            'selling_price': 2499,
            'mrp': 3999,
          },
        ],
      },
      'middle': {
        'placement': {
          'id': 26,
          'vc_name': 'You Might Also Like',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 78,
            'product_id': 37,
            'product_image_url':
                'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&auto=format&fit=crop',
            'product_name': 'Ultra-Lightweight Running Jacket',
            'selling_price': 1499,
            'mrp': 2499,
          },
          {
            'campaign_id': 79,
            'product_id': 38,
            'product_image_url':
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&auto=format&fit=crop',
            'product_name': 'Wireless Noise-Cancelling Earbuds',
            'selling_price': 1599,
            'mrp': 2499,
          },
          {
            'campaign_id': 80,
            'product_id': 39,
            'product_image_url':
                'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&auto=format&fit=crop',
            'product_name': 'Titanium Sports Water Bottle',
            'selling_price': 599,
            'mrp': 999,
          },
          {
            'campaign_id': 81,
            'product_id': 40,
            'product_image_url':
                'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400&auto=format&fit=crop',
            'product_name': 'Velvet Matte Lipstick Set',
            'selling_price': 799,
            'mrp': 1200,
          },
        ],
      },
      'bottom': {
        'placement': {
          'id': 27,
          'vc_name': 'Trending Right Now',
          'ad_type': 'promote_product',
        },
        'ads': [
          {
            'campaign_id': 82,
            'product_id': 41,
            'product_image_url':
                'https://images.unsplash.com/photo-1627124765135-56a5181732e4?w=400&auto=format&fit=crop',
            'product_name': 'Leather Bi-Fold Wallet',
            'selling_price': 899,
            'mrp': 1499,
          },
          {
            'campaign_id': 83,
            'product_id': 42,
            'product_image_url':
                'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400&auto=format&fit=crop',
            'product_name': 'Aviator Metal Sunglasses',
            'selling_price': 1199,
            'mrp': 1999,
          },
          {
            'campaign_id': 84,
            'product_id': 43,
            'product_image_url':
                'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=400&auto=format&fit=crop',
            'product_name': 'Men\'s Solid Round Neck T-Shirt',
            'selling_price': 315,
            'mrp': 799,
          },
          {
            'campaign_id': 85,
            'product_id': 44,
            'product_image_url':
                'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400&auto=format&fit=crop',
            'product_name': 'Smart Fitness Tracker Band',
            'selling_price': 1299,
            'mrp': 1999,
          },
        ],
      },
    },
  };
}
