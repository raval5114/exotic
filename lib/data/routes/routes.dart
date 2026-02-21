import 'package:exotic/Test/AuthTesting.dart';
import 'package:exotic/Test/HomepagesTesting/homepage_testing.dart';
import 'package:exotic/Test/product_showing_testing.dart';
import 'package:exotic/view/homescreen/sections/profile.dart';
import 'package:exotic/view/oderlist/orderList.dart';
import 'package:exotic/view/offersAndCoupens/offersAndCoupens.dart';
import 'package:exotic/view/payment/payment.dart';
import 'package:exotic/view/searchProduct/searchProduct.dart';
import 'package:exotic/view/splashscreen/splashScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/view/auth/auth_main.dart';
import 'package:exotic/view/homescreen/homescreen.dart';
import 'package:exotic/view/homescreen/sections/cart.dart';
import 'package:exotic/view/homescreen/sections/categories.dart';
import 'package:exotic/view/homescreen/sections/homescreen.dart';
import 'package:exotic/view/wishlist/wishlist.dart';

final goRoutes = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Splashscreen()),
    //testing routes
    GoRoute(path: '/test', builder: (context, state) => AuthTesting()),
    // Auth screen (entry point)
    GoRoute(path: '/auth', builder: (context, state) => AuthMainScreen()),
    GoRoute(
      path: '/productsTesting',
      builder: (context, state) => SearchProductTesting(),
    ),
    GoRoute(
      path: '/searchProductPage',
      builder: (context, state) => SearchProductPage(),
    ),
    GoRoute(path: '/wishlist', builder: (context, state) => WishlistScreen()),
    GoRoute(path: '/orderList', builder: (context, state) => OrderListPage()),
    // Shell for main app navigation with bottom navigation
    ShellRoute(
      builder:
          (context, state, child) =>
              Homescreen(location: state.uri.toString(), child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
        GoRoute(
          path: '/categories',
          builder: (context, state) => CategoriesScreen(),
        ),
        GoRoute(path: '/cart', builder: (context, state) => CartScreen()),
        GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
      ],
    ),
    GoRoute(
      path: '/coupensAndOffers',
      builder: (context, state) => OffersandCoupens(),
    ),
    GoRoute(
      path: '/payment',
      builder:
          (context, state) => PaymentScreen(
            productData: {},
            discountedPrice: '',
            intialPrice: '  ',
          ),
    ),
  ],
);
