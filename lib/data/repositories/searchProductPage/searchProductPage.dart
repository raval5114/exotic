abstract class ISearchProductRepo {
  Future<Map<String, dynamic>> searchProduct(String query);
  Future<List<Map<String, dynamic>>> fetchRecentData();
  Future<List<Map<String, dynamic>>> fetchPopularData();
  Future<List<String>> fetchDiscoverData();
  Future<Map<String, dynamic>> fetchSearchSuggestions();
}
