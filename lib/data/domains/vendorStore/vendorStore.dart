import 'package:exotic/data/repositories/vendorStore/vendorStore.dart';
import 'package:exotic/utils/newProductList.dart';

class VendorstoreRepo extends IVendorStoreRepo {
  @override
  Future<List<Map<String, dynamic>>> fetchVendorData() async {
    return products;
  }
}
