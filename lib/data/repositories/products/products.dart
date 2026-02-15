abstract class IProductsRepo {
  Future<List<Map<String, dynamic>>> fetchProductData();
  Future<List<Map<String, dynamic>>> fetchProductForTesting();
  Future<Map<String, dynamic>> fetchProductById(String cid);
}
