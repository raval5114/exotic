import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchProductDiscoverProductTile extends StatelessWidget {
  final String item;

  const SearchProductDiscoverProductTile({super.key, required this.item});

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  static const double _borderRadius = 30;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Text(
        item,
        style: GoogleFonts.roboto(
          fontSize: width * 0.035,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}
