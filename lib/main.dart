import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/blocs/cart/bloc/cart_bloc.dart';
import 'package:exotic/data/blocs/homescreen/categories/bloc/categories_bloc.dart';
import 'package:exotic/data/blocs/homescreen/categories/cubit/subcategories_cubit.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/blocs/orderList/bloc/order_list_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/data/blocs/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:exotic/data/blocs/vendorStore/bloc/vender_bloc.dart';
import 'package:exotic/data/blocs/wishList/bloc/wishlist_bloc.dart';
import 'package:exotic/data/providers/brands_provider.dart';
import 'package:exotic/data/providers/cart_provider.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:exotic/data/providers/meta_data_provider.dart';
import 'package:exotic/data/providers/product_provider.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/providers/wishlist_provider.dart';
import 'package:exotic/data/providers/search_product_provider.dart';
import 'package:exotic/data/providers/order_list_provider.dart';
import 'package:exotic/utils/injection.dart';
import 'package:exotic/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await setUpGetItLocator();
  //testDNS();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getit<UserLoginProvider>()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => BrandsProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => MetaDataProvider()),
        ChangeNotifierProvider(create: (_) => HomepageProvider()),
        ChangeNotifierProvider(create: (_) => SearchProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderListProvider()),

        BlocProvider(create: (_) => FetchProductBloc()),
        BlocProvider(create: (_) => VenderBloc()),
        BlocProvider(create: (_) => SplashScreenBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => HomepageBloc()),
        BlocProvider(create: (_) => CategoriesBloc()),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => WishlistBloc()),
        BlocProvider(create: (_) => SubcategoriesCubit()),
        BlocProvider(create: (_) => SearchProductBloc()),
        BlocProvider(create: (_) => OrderListBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Exotic',
      theme: ThemeData(
        primaryColor: const Color(0xFF9747FF),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF9747FF),
          onPrimary: Colors.white,
          secondary: Color(0xFFB57AFF),
          onSecondary: Colors.white,
          onSecondaryContainer: Color(0xFFD4AFFF),
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      routerConfig: goRoutes,
    );
  }
}
