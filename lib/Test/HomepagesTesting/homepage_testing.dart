import 'dart:convert';
import 'dart:typed_data';
import 'package:exotic/controllers/Homescreen/Homepage/banner_carosol.dart';
import 'package:exotic/data/models/Homepage/elements/mobile-promo-banner.dart';
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
