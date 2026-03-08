import 'package:exotic/data/domains/brands/brands.dart';
import 'package:exotic/data/domains/cart/cart_service.dart';
import 'package:exotic/data/domains/homesrceen/categories/categories.dart';
import 'package:exotic/data/domains/homesrceen/homepage/homepage.dart';
import 'package:exotic/data/domains/homesrceen/homepage/homepage_caching_service.dart';
import 'package:exotic/data/domains/product.dart';
import 'package:exotic/data/domains/searchProduct/searchProduct.dart';
import 'package:exotic/data/domains/wishlist/wishlist.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getit = GetIt.instance;

Future<void> setUpGetItLocator() async {
  /// Open Hive box
  final homepageCacheBox = await Hive.openBox('homepageCache');

  /// Register Hive box
  getit.registerLazySingleton<Box>(() => homepageCacheBox);

  /// Register caching service
  getit.registerLazySingleton<HomepageCachingService>(
    () => HomepageCachingService(getit<Box>()),
  );

  /// Other services
  getit.registerLazySingleton<HomePageRepo>(() => HomePageRepo());
  getit.registerLazySingleton<CategoriesRepo>(() => CategoriesRepo());
  getit.registerLazySingleton<ProductService>(() => ProductService());
  getit.registerLazySingleton<BrandsServices>(() => BrandsServices());
  getit.registerLazySingleton<CartService>(() => CartService());
  getit.registerLazySingleton<SearchproductRepo>(() => SearchproductRepo());
  getit.registerLazySingleton<WishlistService>(() => WishlistService());
  getit.registerLazySingleton<UserLoginProvider>(() => UserLoginProvider());
}
