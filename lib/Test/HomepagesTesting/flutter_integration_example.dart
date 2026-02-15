// Flutter Integration Example for Xotic Elements API
//
// This file demonstrates how to integrate the Elements API
// into your Flutter mobile application

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// ============================================================================
// API SERVICE
// ============================================================================

class ElementsApiService {
  static const String baseUrl = 'https://xotic.in/api/elements';

  /// Fetch page content by slug
  Future<PageResponse> fetchPage(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/page.php?slug=$slug'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PageResponse.fromJson(data);
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching page: $e');
    }
  }

  /// Fetch list of all pages
  Future<PagesListResponse> fetchPagesList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pages.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PagesListResponse.fromJson(data);
      } else {
        throw Exception('Failed to load pages list');
      }
    } catch (e) {
      throw Exception('Error fetching pages: $e');
    }
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

class PageResponse {
  final bool success;
  final int timestamp;
  final PageData page;

  PageResponse({
    required this.success,
    required this.timestamp,
    required this.page,
  });

  factory PageResponse.fromJson(Map<String, dynamic> json) {
    return PageResponse(
      success: json['success'] ?? false,
      timestamp: json['timestamp'] ?? 0,
      page: PageData.fromJson(json['page'] ?? {}),
    );
  }
}

class PageData {
  final int pageId;
  final String title;
  final String slug;
  final MetaData meta;
  final List<RowData> rows;

  PageData({
    required this.pageId,
    required this.title,
    required this.slug,
    required this.meta,
    required this.rows,
  });

  factory PageData.fromJson(Map<String, dynamic> json) {
    return PageData(
      pageId: json['page_id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      meta: MetaData.fromJson(json['meta'] ?? {}),
      rows:
          (json['rows'] as List?)
              ?.map((row) => RowData.fromJson(row))
              .toList() ??
          [],
    );
  }
}

class MetaData {
  final String title;
  final String description;
  final String keywords;

  MetaData({
    required this.title,
    required this.description,
    required this.keywords,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      keywords: json['keywords'] ?? '',
    );
  }
}

class RowData {
  final int rowId;
  final int layoutType;
  final StylingData styling;
  final List<ElementData> elements;

  RowData({
    required this.rowId,
    required this.layoutType,
    required this.styling,
    required this.elements,
  });

  factory RowData.fromJson(Map<String, dynamic> json) {
    return RowData(
      rowId: json['row_id'] ?? 0,
      layoutType: json['layout_type'] ?? 1,
      styling: StylingData.fromJson(json['styling'] ?? {}),
      elements:
          (json['elements'] as List?)
              ?.map((element) => ElementData.fromJson(element))
              .toList() ??
          [],
    );
  }
}

class StylingData {
  final String backgroundColor;
  final String? backgroundImage;
  final String height;
  final String padding;
  final String margin;

  StylingData({
    required this.backgroundColor,
    this.backgroundImage,
    required this.height,
    required this.padding,
    required this.margin,
  });

  factory StylingData.fromJson(Map<String, dynamic> json) {
    return StylingData(
      backgroundColor: json['background_color'] ?? '#ffffff',
      backgroundImage: json['background_image'],
      height: json['height'] ?? 'auto',
      padding: json['padding'] ?? '0',
      margin: json['margin'] ?? '0',
    );
  }
}

class ElementData {
  final int elementId;
  final String elementType;
  final String title;
  final Map<String, dynamic> config;
  final dynamic data; // Can be products, items, banners, etc.

  ElementData({
    required this.elementId,
    required this.elementType,
    required this.title,
    required this.config,
    this.data,
  });

  factory ElementData.fromJson(Map<String, dynamic> json) {
    return ElementData(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      config: json['config'] ?? {},
      data: json['products'] ?? json['items'] ?? json['banners'],
    );
  }
}

class Product {
  final int productId;
  final String name;
  final String shortDescription;
  final String imageUrl;
  final PriceData price;
  final RatingData rating;
  final BadgesData badges;
  final String url;

  Product({
    required this.productId,
    required this.name,
    required this.shortDescription,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.badges,
    required this.url,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: PriceData.fromJson(json['price'] ?? {}),
      rating: RatingData.fromJson(json['rating'] ?? {}),
      badges: BadgesData.fromJson(json['badges'] ?? {}),
      url: json['url'] ?? '',
    );
  }
}

class PriceData {
  final double sellingPrice;
  final double mrpPrice;
  final int discountPercentage;

  PriceData({
    required this.sellingPrice,
    required this.mrpPrice,
    required this.discountPercentage,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      mrpPrice: (json['mrp_price'] ?? 0).toDouble(),
      discountPercentage: json['discount_percentage'] ?? 0,
    );
  }
}

class RatingData {
  final double average;
  final int count;

  RatingData({required this.average, required this.count});

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}

class BadgesData {
  final String? ribbon;
  final String? deal;
  final bool freeShipping;

  BadgesData({this.ribbon, this.deal, required this.freeShipping});

  factory BadgesData.fromJson(Map<String, dynamic> json) {
    return BadgesData(
      ribbon: json['ribbon'],
      deal: json['deal'],
      freeShipping: json['free_shipping'] ?? false,
    );
  }
}

class PagesListResponse {
  final bool success;
  final int timestamp;
  final int count;
  final List<PageSummary> pages;

  PagesListResponse({
    required this.success,
    required this.timestamp,
    required this.count,
    required this.pages,
  });

  factory PagesListResponse.fromJson(Map<String, dynamic> json) {
    return PagesListResponse(
      success: json['success'] ?? false,
      timestamp: json['timestamp'] ?? 0,
      count: json['count'] ?? 0,
      pages:
          (json['pages'] as List?)
              ?.map((page) => PageSummary.fromJson(page))
              .toList() ??
          [],
    );
  }
}

class PageSummary {
  final int pageId;
  final String title;
  final String slug;

  PageSummary({required this.pageId, required this.title, required this.slug});

  factory PageSummary.fromJson(Map<String, dynamic> json) {
    return PageSummary(
      pageId: json['page_id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

/// UI WIDGETS
/// ============================================================================

/// Main HomePage Widget
class HomePageTesting extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageTesting> {
  final ElementsApiService _apiService = ElementsApiService();
  PageResponse? _pageData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHomePage();
  }

  Future<void> _loadHomePage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final pageData = await _apiService.fetchPage('homepage');
      setState(() {
        _pageData = pageData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text('Error loading page'),
              SizedBox(height: 8),
              ElevatedButton(onPressed: _loadHomePage, child: Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_pageData?.page.title ?? 'Home')),
      body: RefreshIndicator(
        onRefresh: _loadHomePage,
        child: ListView.builder(
          itemCount: _pageData?.page.rows.length ?? 0,
          itemBuilder: (context, index) {
            final row = _pageData!.page.rows[index];
            return _buildRow(row);
          },
        ),
      ),
    );
  }

  Widget _buildRow(RowData row) {
    return Container(
      color: _parseColor(row.styling.backgroundColor),
      padding: _parsePadding(row.styling.padding),
      margin: _parsePadding(row.styling.margin),
      child: Column(
        children:
            row.elements.map((element) => _buildElement(element)).toList(),
      ),
    );
  }

  Widget _buildElement(ElementData element) {
    switch (element.elementType) {
      case 'banner':
        return BannerCarouselWidget(element: element);
      case 'product_gallery_1':
      case 'product_gallery_2':
      case 'product_gallery_3':
      case 'product_gallery_4':
        return ProductGalleryWidget(element: element);
      case 'product_grid':
        return ProductGridWidget(element: element);
      case 'product_grid_vertical':
      case 'product_grid_vertical2':
        return ProductGridVerticalWidget(element: element);
      default:
        return SizedBox.shrink();
    }
  }

  Color _parseColor(String colorString) {
    return Color(
      int.parse(colorString.substring(1, 7), radix: 16) + 0xFF000000,
    );
  }

  EdgeInsets _parsePadding(String paddingString) {
    // Simple parser - you can make this more sophisticated
    final value = double.tryParse(paddingString.replaceAll('px', '')) ?? 0;
    return EdgeInsets.all(value);
  }
}

/// Banner Carousel Widget
class BannerCarouselWidget extends StatelessWidget {
  final ElementData element;

  const BannerCarouselWidget({required this.element});

  @override
  Widget build(BuildContext context) {
    final banners =
        (element.data as List?)
            ?.map((b) => b as Map<String, dynamic>)
            .toList() ??
        [];

    return Container(
      height: 200,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return GestureDetector(
            onTap: () {
              // Navigate to banner link
              print('Navigate to: ${banner['link_url']}');
            },
            child: Image.network(
              banner['image_url'] ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Product Gallery Widget
class ProductGalleryWidget extends StatelessWidget {
  final ElementData element;

  const ProductGalleryWidget({required this.element});

  @override
  Widget build(BuildContext context) {
    final products =
        (element.data as List?)
            ?.map((p) => Product.fromJson(p as Map<String, dynamic>))
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                element.config['gallery_title'] ?? element.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (element.config['view_more_url'] != null)
                TextButton(
                  onPressed: () {
                    // Navigate to view more
                  },
                  child: Text('View More'),
                ),
            ],
          ),
        ),
        Container(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}

/// Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (product.badges.ribbon != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.badges.ribbon!,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.sellingPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      if (product.price.discountPercentage > 0)
                        Text(
                          '${product.price.discountPercentage}% off',
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product Grid Widget
class ProductGridWidget extends StatelessWidget {
  final ElementData element;

  const ProductGridWidget({required this.element});

  @override
  Widget build(BuildContext context) {
    final items =
        (element.data as List?)
            ?.map((i) => i as Map<String, dynamic>)
            .toList() ??
        [];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            // Navigate to item link
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    item['image_url'] ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    item['title'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Product Grid Vertical Widget
class ProductGridVerticalWidget extends StatelessWidget {
  final ElementData element;

  const ProductGridVerticalWidget({required this.element});

  @override
  Widget build(BuildContext context) {
    // Similar implementation to ProductGridWidget
    // but with vertical layout and more details
    return Container(child: Text('Product Grid Vertical - ${element.title}'));
  }
}
