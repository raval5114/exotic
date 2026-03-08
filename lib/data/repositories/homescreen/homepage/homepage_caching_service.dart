abstract class IHomepageCachingService {
  Future<void> cacheTabs(List<Map<String, dynamic>> tabs);
  Future<List<Map<String, dynamic>>> getCachedTabs();
  Future<void> cacheHomepage(
    String slug,
    String version,
    Map<String, dynamic> page,
  );
  Map<String, dynamic>? getCachedHomepage(String slug);
  Future<void> clearCachedTabs();
}
