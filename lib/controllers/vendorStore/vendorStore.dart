import 'package:exotic/controllers/vendorStore/vendorStoreProductsComponent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VenderStoreComponent extends StatelessWidget {
  final String venderName;
  final String ratings;
  final String raters;
  final String followings;
  final List<Map<String, dynamic>> products;
  const VenderStoreComponent({
    super.key,
    required this.venderName,
    required this.ratings,
    required this.followings,
    required this.products,
    required this.raters,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner area with stack
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: screenWidth,
                  height: 155,
                  child: const Placeholder(),
                ),

                // Vendor Info (overlaying bottom of banner)
                Positioned(
                  bottom: -65,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Trusted",
                              style: GoogleFonts.roboto(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${venderName}",
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Store icon (slightly below text)
                Positioned(
                  bottom: -30,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(
                        Icons.store,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // Rating + Followers + Products + Follow Button
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 400;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _infoBox("$ratings ★", "19,166 ratings"),
                      _infoBox("$followings", "Followers"),
                      _infoBox("${products.length}", "Product"),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Follow",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Placeholder for future content
            VendorStoreProductComponents(),
          ],
        ),
      ),
    );
  }

  static Widget _infoBox(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        Text(
          subtitle,
          style: GoogleFonts.roboto(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
