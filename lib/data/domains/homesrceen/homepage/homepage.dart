import 'dart:convert';
import 'package:exotic/data/domains/homesrceen/homepage/homepage_caching_service.dart';
import 'package:exotic/data/repositories/homescreen/homepage/homepage.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class HomePageRepo extends IHomePageRepo {
  @override
  Future<Map<String, dynamic>> getHomePageData({
    String slug = "homepage",
  }) async {
    try {
      final cacheService = getit<HomepageCachingService>();

      /// Get cached homepage
      final cached = cacheService.getCachedHomepage(slug);

      /// Get cached tabs
      final cachedTabs = await cacheService.getCachedTabs();

      String? tabVersion;

      final tab = cachedTabs.firstWhere(
        (e) => e['slug'] == slug,
        orElse: () => {},
      );

      if (tab.isNotEmpty) {
        tabVersion = tab['created_at'];
      }

      /// If cache exists and version matches
      if (cached != null && tabVersion != null) {
        if (cached['version'] == tabVersion) {
          return jsonDecode(jsonEncode(cached['page']));
        }
      }

      /// Call API
      var response = await http.get(
        Uri.parse('https://xotic.in/api/elements/page.php?slug=$slug'),
      );

      if (response.statusCode != 200) {
        if (cached != null) {
          return jsonDecode(jsonEncode(cached['page']));
        }
        throw Exception('Failed to load homepage data');
      }

      var decoded = jsonDecode(response.body);

      if (decoded['success'] != true || decoded['page'] == null) {
        if (cached != null) {
          return jsonDecode(jsonEncode(cached['page']));
        }
        throw Exception('API returned success false');
      }

      final page = Map<String, dynamic>.from(decoded['page']);

      /// Save new cache using tab version
      if (tabVersion != null) {
        await cacheService.cacheHomepage(slug, tabVersion, page);
      }

      return page;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getHomepageTabsData() async {
    final cachedTabs = await getit<HomepageCachingService>().getCachedTabs();

    final uri = Uri.parse("https://xotic.in/api/elements/pages.php");
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      if (cachedTabs != null) {
        return cachedTabs; // fallback to cache if API fails
      }
      throw Exception("Failed to load homepage pages");
    }

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (decoded['success'] != true) {
      if (cachedTabs != null) {
        return cachedTabs;
      }
      throw Exception("API returned failure");
    }

    final List pages = decoded['pages'];

    final apiTabs =
        pages
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();

    /// Generate version key from created_at
    final apiVersion = apiTabs.map((e) => e['created_at']).join('|');

    if (cachedTabs != null) {
      final cacheVersion = cachedTabs.map((e) => e['created_at']).join('|');

      if (apiVersion == cacheVersion) {
        debugPrint("Returning Cached Tabs");
        return cachedTabs;
      }
    }

    /// Cache new data
    await getit<HomepageCachingService>().cacheTabs(apiTabs);
    debugPrint("Returning API Tabs");
    return apiTabs;
  }
}
