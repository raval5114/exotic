import 'package:exotic/Test/HomepagesTesting/model/bannertesting.dart';
import 'package:exotic/controllers/Homescreen/Homepage/banner_carosol.dart';
import 'package:exotic/controllers/Homescreen/Homepage/imageGalleryCarosol.dart';
import 'package:exotic/controllers/Homescreen/Homepage/productGridVertical.dart';
import 'package:exotic/controllers/Homescreen/Homepage/productGridVertical2.dart';
import 'package:exotic/controllers/Homescreen/Homepage/product_gallery.dart';
import 'package:exotic/controllers/Homescreen/Homepage/product_grid.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/Homepage/elements/Product_grid.dart';
import 'package:exotic/data/models/Homepage/elements/configs/ProductGalleryConfig.dart';
import 'package:exotic/data/models/Homepage/elements/image_gallery.dart';
import 'package:exotic/data/models/Homepage/elements/product_gallery.dart';
import 'package:exotic/data/models/Homepage/elements/product_grid_vertical.dart';
import 'package:exotic/data/models/Homepage/elements/product_grid_vertical_2.dart';
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
        if (element is BannerElement) {
          widgets.add(BannerCarouselWidget(content: element.content));
        } else if (element is ImageGallery) {
          widgets.add(ImageGalleryCarouselWidget(content: element.content));
        } else if (element is ProductGallery) {
          widgets.add(
            ProductGalleryWidget(
              title: element.title,
              config: element.config,
              products: element.items,
            ),
          );
        } else if (element is ProductGrid) {
          widgets.add(ProductGridWidget(grid: element));
        } else if (element is ProductGridVertical) {
          widgets.add(ProductGridVerticalWidget(element: element));
        } else if (element is ProductGridVertical2) {
          widgets.add(ProductGridVertical2Widget(products: element.products));
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
