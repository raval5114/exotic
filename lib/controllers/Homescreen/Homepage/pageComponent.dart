import 'package:exotic/controllers/Homescreen/Homepage/rowPage.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/domains/ads/widgets/ad_block.dart';
import 'package:flutter/material.dart';

class Pagecomponent extends StatelessWidget {
  final Pagemodel pageData;

  const Pagecomponent({super.key, required this.pageData});

  @override
  Widget build(BuildContext context) {
    final List<Rows> rows = pageData.rows;
    final int midIndex = rows.length ~/ 2;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dynamic Top Ad Placement
          const AdBlock(page: 'homepage', position: 'top', limit: 3),

          ...List.generate(rows.length * 2 - 1, (index) {
            final rowIndex = index ~/ 2;
            if (index.isEven) {
              // Each section row — rowPage.dart handles its own internal padding
              final rowWidget = RowPageComponent(rows: rows[rowIndex]);

              // Dynamically inject Middle Ad Placement right after the middle row
              if (rowIndex == midIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    rowWidget,
                    const SizedBox(height: 12),
                    const AdBlock(page: 'homepage', position: 'middle', limit: 4),
                  ],
                );
              }

              return rowWidget;
            } else {
              // Section divider — subtle gray stripe between rows
              return const _SectionDivider();
            }
          }),

          // Dynamic Bottom Ad Placement
          const AdBlock(page: 'homepage', position: 'bottom', limit: 3),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Subtle section separator between homepage rows — Flipkart/Myntra style
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: const Color(0xFFF1F3F6),
    );
  }
}
