import 'dart:convert';
import 'dart:typed_data';
import 'package:exotic/Test/HomepagesTesting/homepage_products.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/banner_carosol.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_category_grid.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/Homepage/elements/mobile-promo-banner.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_category_strip.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_grid_offer.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/Test/HomepagesTesting/bloc/homepage_testing_bloc.dart';

// class HomepageTestingWithServiceComponent extends StatefulWidget {
//   const HomepageTestingWithServiceComponent({super.key});

//   @override
//   State<HomepageTestingWithServiceComponent> createState() =>
//       _HomepageTestingWithServiceComponentState();
// }

// class _HomepageTestingWithServiceComponentState
//     extends State<HomepageTestingWithServiceComponent> {
//   String _cleanBase64(String base64String) {
//     if (base64String.contains(',')) {
//       return base64String.split(',').last;
//     }
//     return base64String;
//   }

//   Uint8List _base64ToBytes(String base64String) {
//     return base64Decode(_cleanBase64(base64String));
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: BlocConsumer<HomepageTestingBloc, HomepageTestingState>(
//         listener: (context, state) {
//           // You can show snackbar etc here
//         },
//         builder: (context, state) {
//           if (state is HomepageTestingLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is HomepageErrorState) {
//             return Center(child: Text(state.errMsg ?? "Something went wrong"));
//           }

//           if (state is HomepageTestingSuccessState) {
//             final elements = state.data['elements'][0];
//             if (elements is List && elements.isNotEmpty) {
//               final MobilePromoBanner mobilePromoBanner =
//                   MobilePromoBanner.fromJson(state.data['elements'][0]);
//               final elementData = elements[0]['data'];
//               if (elementData is Map && elementData.containsKey('banners')) {
//                 final banners = mobilePromoBanner.items;
//                 if (banners.isNotEmpty) {
//                   return BannerCarouselWidget(banners: banners);
//                 }
//               }
//             }
//             return const Center(child: Text("No banners available"));
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }

class HomepageTestingWithService extends StatelessWidget {
  const HomepageTestingWithService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => HomepageTestingBloc()..add(HomepageTestingEvent()),
        child: const HomepageTestingWithServiceComponent(),
      ),
    );
  }
}

class HomepageTestingWithServiceComponent extends StatefulWidget {
  const HomepageTestingWithServiceComponent({super.key});

  @override
  State<HomepageTestingWithServiceComponent> createState() =>
      _HomepageTestingWithServiceComponentState();
}

class _HomepageTestingWithServiceComponentState
    extends State<HomepageTestingWithServiceComponent> {
  MobileCategoryGridElement
  mobileCategoryGridElement = MobileCategoryGridElement.fromJson({
    "element_id": 149,
    "element_type": "mobile-category-grid",
    "title": "test 7",
    "data": {
      "items": [
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/a6189afdd765a687.jpg?q=80",
          "title": "Valentine's",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/f9ebd80a4825f28e.jpg?q=80",
          "title": "Tshirt...",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d31d524f681630af.jpg?q=80",
          "title": "Jeans",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/9be859f78d39cc22.jpg?q=80",
          "title": "Sports Shoes",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/38e2f5617d0edd27.png?q=80",
          "title": "Watches",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d7eae409dc461a54.jpg?q=80",
          "title": "Kids",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d7eae409dc461a54.jpg?q=80",
          "title": "Kids",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d7eae409dc461a54.jpg?q=80",
          "title": "Kids",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d7eae409dc461a54.jpg?q=80",
          "title": "Kids",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d7eae409dc461a54.jpg?q=80",
          "title": "Kids",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d7eae409dc461a54.jpg?q=80",
          "title": "Kids",
          "url": "#",
        },
        {
          "img":
              "https://rukminim2.flixcart.com/fk-p-flap/98/98/image/d7eae409dc461a54.jpg?q=80",
          "title": "Kids",
          "url": "#",
        },
      ],
    },
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomepageProvider>().setPage(
        Pagemodel.fromJson(HomepageData['page']),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MobileCategoryGridComponent(element: mobileCategoryGridElement),
    );
  }
}
