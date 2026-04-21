abstract class IProductViewerRepo {
  Future<Map<String, dynamic>> fetchProductDetails(String url);
}
