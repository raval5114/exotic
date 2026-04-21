import 'package:flutter/material.dart';

class SearchedItemsList {
  final List<SearchedItems> items;
  final Filters filters;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final int showingFrom;
  final int showingTo;
  SearchedItemsList({
    required this.items,
    required this.filters,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.showingFrom,
    required this.showingTo,
  });
  factory SearchedItemsList.fromJson(Map<String, dynamic> json) {
    return SearchedItemsList(
      items:
          (json['results']['products'] as List)
              .map((i) => SearchedItems.fromJson(i))
              .toList(),
      filters: Filters.fromJson(json['filters']),
      total: json['results']['total'],
      page: json['results']['page'],
      limit: json['results']['limit'],
      totalPages: json['results']['total_pages'],
      showingFrom: json['results']['showing_from'],
      showingTo: json['results']['showing_to'],
    );
  }
}

class SearchedItems {
  final String? id;
  final String? name;
  final String? sku;
  final String? image;
  final SearchedItemPrice? price;
  final SearchedItemStock? stock;
  final String? category;
  final String? brand;
  final int? relevanceScore;
  final String? url;

  SearchedItems({
    this.id,
    this.name,
    this.sku,
    this.image,
    this.price,
    this.stock,
    this.category,
    this.brand,
    this.relevanceScore,
    this.url,
  });

  factory SearchedItems.fromJson(Map<String, dynamic> json) {
    return SearchedItems(
      id: json['id']?.toString(),
      name: json['name'],
      sku: json['sku'],
      image: json['image'],
      price:
          json['price'] != null
              ? SearchedItemPrice.fromJson(json['price'])
              : null,
      stock:
          json['stock'] != null
              ? SearchedItemStock.fromJson(json['stock'])
              : null,
      category: json['category'],
      brand: json['brand'],
      relevanceScore: json['relevance_score'],
      url: json['url'],
    );
  }
}

class SearchedItemPrice {
  final int? selling;
  final int? mrp;
  final int? discountPercentage;

  SearchedItemPrice({this.selling, this.mrp, this.discountPercentage});

  factory SearchedItemPrice.fromJson(Map<String, dynamic> json) {
    return SearchedItemPrice(
      selling:
          json['selling'] is int
              ? json['selling']
              : int.tryParse(json['selling'].toString()),
      mrp:
          json['mrp'] is int
              ? json['mrp']
              : int.tryParse(json['mrp'].toString()),
      discountPercentage:
          json['discount_percentage'] is int
              ? json['discount_percentage']
              : int.tryParse(json['discount_percentage'].toString()),
    );
  }
}

class SearchedItemStock {
  final int? quantity;
  final String? status;
  final String? unit;

  SearchedItemStock({this.quantity, this.status, this.unit});

  factory SearchedItemStock.fromJson(Map<String, dynamic> json) {
    return SearchedItemStock(
      quantity:
          json['quantity'] is int
              ? json['quantity']
              : int.tryParse(json['quantity'].toString()),
      status: json['status'],
      unit: json['unit'],
    );
  }
}

class Filters {
  final List<FilterCategory>? categories;
  final List<FilterBrand>? brands;
  final PriceRange? priceRange;

  Filters({this.categories, this.brands, this.priceRange});

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      categories:
          json['categories'] != null
              ? (json['categories'] as List)
                  .map((i) => FilterCategory.fromJson(i))
                  .toList()
              : null,
      brands:
          json['brands'] != null
              ? (json['brands'] as List)
                  .map((i) => FilterBrand.fromJson(i))
                  .toList()
              : null,
      priceRange:
          json['price_range'] != null
              ? PriceRange.fromJson(json['price_range'])
              : null,
    );
  }
}

class FilterCategory {
  final String? id;
  final String? name;
  final int? count;

  FilterCategory({this.id, this.name, this.count});

  factory FilterCategory.fromJson(Map<String, dynamic> json) {
    return FilterCategory(
      id: json['id']?.toString(),
      name: json['name'],
      count:
          json['count'] is int
              ? json['count']
              : int.tryParse(json['count']?.toString() ?? ''),
    );
  }
}

class FilterBrand {
  final String? id;
  final String? name;
  final int? count;

  FilterBrand({this.id, this.name, this.count});

  factory FilterBrand.fromJson(Map<String, dynamic> json) {
    return FilterBrand(
      id: json['id']?.toString(),
      name: json['name'],
      count:
          json['count'] is int
              ? json['count']
              : int.tryParse(json['count']?.toString() ?? ''),
    );
  }
}

class PriceRange {
  final int? min;
  final int? max;

  PriceRange({this.min, this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min:
          json['min'] is int
              ? json['min']
              : int.tryParse(json['min'].toString()),
      max:
          json['max'] is int
              ? json['max']
              : int.tryParse(json['max'].toString()),
    );
  }
}
