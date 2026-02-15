import 'package:exotic/data/domains/brands/brands.dart';
import 'package:exotic/data/domains/cart/cart_service.dart';
import 'package:exotic/data/domains/homesrceen/categories/categories.dart';
import 'package:exotic/data/domains/homesrceen/homepage/homepage.dart';
import 'package:exotic/data/domains/product.dart';
import 'package:exotic/data/domains/searchProduct/searchProduct.dart';
import 'package:exotic/data/domains/wishlist/wishlist.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;
void setUpGetItLocator() {
  getit.registerLazySingleton<HomePageRepo>(() => HomePageRepo());
  getit.registerLazySingleton<CategoriesRepo>(() => CategoriesRepo());
  getit.registerLazySingleton<ProductService>(() => ProductService());
  getit.registerLazySingleton<BrandsServices>(() => BrandsServices());
  getit.registerLazySingleton<CartService>(() => CartService());
  getit.registerLazySingleton<SearchproductRepo>(() => SearchproductRepo());
  getit.registerLazySingleton<WishlistService>(() => WishlistService());
}
