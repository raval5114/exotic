import 'package:exotic/controllers/Homescreen/Homepage/banner_carosol.dart';
import 'package:exotic/controllers/Homescreen/Homepage/product_gallery.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/Homepage/elements/mobile-promo-banner.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_suggestion_grid.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';
import 'package:flutter/material.dart';

class RowPageComponent extends StatefulWidget {
  final Rows rows;
  const RowPageComponent({super.key, required this.rows});

  @override
  State<RowPageComponent> createState() => _RowPageComponentState();
}

class _RowPageComponentState extends State<RowPageComponent> {
  @override
  Widget build(BuildContext context) {
    Styling styling = widget.rows.styling;
    Color hexToColor(String hex) {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex'; // add full opacity
      }
      return Color(int.parse(hex, radix: 16));
    }

    List<Widget> parseElementToWidget(List<PageElement> elements) {
      List<Widget> widgets = [];
      for (final element in elements) {
        if (element is MobilePromoBanner) {
          widgets.add(BannerCarouselWidget(banners: element.items));
        } else if (element is MobileSuggestionGrid) {
          widgets.add(
            MobileSuggestionProducts(
              title: element.title,
              config: element.config,
              products: element.items,
            ),
          );
        } else {
          debugPrint('Unhandled PageElement: ${element.runtimeType}');
        }
      }

      return widgets;
    }

    return Container(
      decoration: BoxDecoration(color: hexToColor(styling.backgroud_color)),
      child: Column(children: parseElementToWidget(widget.rows.elements)),
    );
  }
}
