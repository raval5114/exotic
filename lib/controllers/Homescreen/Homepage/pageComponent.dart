import 'package:exotic/controllers/Homescreen/Homepage/rowPage.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:flutter/material.dart';

class Pagecomponent extends StatelessWidget {
  final Pagemodel pageData;

  const Pagecomponent({super.key, required this.pageData});

  @override
  Widget build(BuildContext context) {
    final List<Rows> rows = pageData.rows;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(rows.length * 2 - 1, (index) {
          if (index.isEven) {
            return RowPageComponent(rows: rows[index ~/ 2]);
          } else {
            return Container(
              height: 8,
              color: const Color(
                0xFFF1F2F4,
              ), // Flipkart style light-grey module separator
            );
          }
        }),
      ),
    );
  }
}
