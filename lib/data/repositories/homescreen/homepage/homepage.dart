abstract class IHomePageRepo {
  Future<List<String>> getAdIamge();
  List<Map<String, dynamic>> getCategories();
  List<Map<String, dynamic>> getSectionDataImages();
  List<Map<String, dynamic>> getSectionDataProducsts();
}

abstract class IHomepageRepo {
  Future<Map<String, dynamic>> getHomePageData();
}
