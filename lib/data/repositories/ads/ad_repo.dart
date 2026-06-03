abstract class AdRepo {
  Future<Map<String, dynamic>?> fetchAdPlacement({
    required String page,
    required String position,
    int? userId,
    int? categoryId,
    String? keyword,
    int limit = 3,
  });
  Future<Map<String, dynamic>?> trackClick({
    required int campaignId,
    required String adType,
    int? productId,
    int? bannerId,
    int? placementId,
    int? userId,
  });
  Future<bool> trackConversion({
    required int campaignId,
    required int orderId,
    int? userId,
    int? clickId,
    int? productId,
    double? conversionValue,
  });
}
