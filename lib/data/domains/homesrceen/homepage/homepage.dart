import 'dart:convert';

import 'package:exotic/Test/HomepagesTesting/product.dart';
import 'package:exotic/data/repositories/homescreen/homepage/homepage.dart';
import 'package:exotic/utils/adImages.dart';
import 'package:exotic/utils/categories.dart';
import 'package:exotic/utils/newProductList.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class HomePageRepo extends IHomePageRepo {
  @override
  Future<List<String>> getAdIamge() async {
    // TODO: implement getAdIamge
    return AdImages;
  }

  @override
  List<Map<String, dynamic>> getCategories() {
    return categories;
  }

  @override
  List<Map<String, dynamic>> getSectionDataImages() {
    // TODO: implement getSectionData
    return AdImagesMapped;
  }

  @override
  List<Map<String, dynamic>> getSectionDataProducsts() {
    // TODO: implement getSectionDataProducsts
    return products;
  }

  @override
  Future<Map<String, dynamic>> getHomePageData() async {
    try {
      var response = await http.get(
        Uri.parse('https://xotic.in/api/elements/page.php?slug=homepage'),
      );

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        debugPrint("Working");
        // Check if the API call was successful
        if (decoded['success'] == true && decoded['page'] != null) {
          // Extract rows from the page data
          return decoded['page'];
          // Convert to List<Map<String, dynamic>>
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load homepage data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
