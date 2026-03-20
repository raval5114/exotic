import 'package:exotic/controllers/offersAndCoupens/offersAndCoupensComponent.dart';
import 'package:flutter/material.dart';

class OffersandCoupens extends StatelessWidget {
  const OffersandCoupens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coupons",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: OffersAndCouponsComponent(),
    );
  }
}
