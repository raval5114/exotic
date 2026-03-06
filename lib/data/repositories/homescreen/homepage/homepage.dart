abstract class IHomePageRepo {
  Future<Map<String, dynamic>> getHomePageData();
  Future<List<Map<String, dynamic>>> getHomepageTabsData();
}
