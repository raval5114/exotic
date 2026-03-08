import 'dart:convert';

import 'package:exotic/data/repositories/homescreen/homepage/homepage_caching_service.dart';
import 'package:hive/hive.dart';

class HomepageCachingService extends IHomepageCachingService {
  final Box box;
  HomepageCachingService(this.box);
  static const String tabsKey = 'tabs';
  String _pageKey(String slug) => 'homepage_page_$slug';
  @override
  Future<void> cacheTabs(List<Map<String, dynamic>> tabs) async {
    await box.put(tabsKey, tabs);
  }

  @override
  Future<void> cacheHomepage(
    String slug,
    String version,
    Map<String, dynamic> page,
  ) async {
    await box.put(
      _pageKey(slug),
      jsonEncode({"version": version, "page": page}),
    );
  }

  @override
  Map<String, dynamic>? getCachedHomepage(String slug) {
    final data = box.get(_pageKey(slug));

    if (data == null) return null;

    dynamic decoded;

    if (data is String) {
      decoded = jsonDecode(data);
    } else {
      decoded = data;
    }

    return jsonDecode(jsonEncode(decoded));
  }

  @override
  Future<void> clearCachedTabs() async {
    await box.delete(tabsKey);
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedTabs() async {
    final data = box.get(tabsKey);
    if (data == null) {
      return [];
    }
    return (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
    // return data['tabs'];
  }
}
