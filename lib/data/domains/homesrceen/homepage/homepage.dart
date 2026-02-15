import 'package:exotic/data/repositories/homescreen/homepage/homepage.dart';
import 'package:exotic/utils/adImages.dart';
import 'package:exotic/utils/categories.dart';
import 'package:exotic/utils/newProductList.dart';
import 'package:exotic/utils/products.dart';

class HomePageRepo extends IHomePageRepo {
  @override
  Future<List<String>> getAdIamge() async {
    // TODO: implement getAdIamge
    return AdImages;
  }

  @override
  List<Map<String, dynamic>> getCategories() {
    return categories;
  }

  @override
  List<Map<String, dynamic>> getSectionDataImages() {
    // TODO: implement getSectionData
    return AdImagesMapped;
  }

  @override
  List<Map<String, dynamic>> getSectionDataProducsts() {
    // TODO: implement getSectionDataProducsts
    return products;
  }
}
