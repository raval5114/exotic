import 'package:exotic/Test/HomepagesTesting/flutter_integration_example.dart';
import 'package:exotic/Test/HomepagesTesting/model/bannertesting.dart';
import 'package:exotic/data/models/Homepage/elements/Product_grid.dart';
import 'package:exotic/data/models/Homepage/elements/banner_carosul.dart';
import 'package:exotic/data/models/Homepage/elements/image_gallery.dart';
import 'package:exotic/data/models/Homepage/elements/product_gallery.dart';
import 'package:exotic/data/models/Homepage/elements/product_grid_vertical.dart';
import 'package:exotic/data/models/Homepage/elements/product_grid_vertical_2.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Styling {
  final String backgroud_color;
  final String backgroud_image;
  final String height;

  final String padding;
  final String margin;
  final String border_radius;
  final String border_width;
  final String border_style;
  final String border_color;
  Styling({
    required this.backgroud_color,
    required this.backgroud_image,
    required this.height,
    required this.padding,
    required this.margin,
    required this.border_radius,
    required this.border_width,
    required this.border_style,
    required this.border_color,
  });
  factory Styling.fromJson(Map<String, dynamic> e) {
    return Styling(
      backgroud_color: e['background_color'] ?? '',
      backgroud_image: e['background_image'] ?? '',
      height: e['height'] ?? '',
      padding: e['padding'] ?? '',
      margin: e['margin'] ?? '',
      border_radius: e['border_radius'] ?? '',
      border_width: e['border_width'] ?? '',
      border_style: e['border_style'] ?? '',
      border_color: e['border_color'] ?? '',
    );
  }
}

class Rows {
  final int row_id;
  final int layout_id;
  final Styling styling;
  final List<PageElement> elements;

  Rows({
    required this.row_id,
    required this.layout_id,
    required this.styling,
    required this.elements,
  });

  /// Parse individual elements based on their type
  static PageElement? _parseElement(Map<String, dynamic> elementData) {
    final elementType = elementData['element_type'] as String?;

    try {
      switch (elementType) {
        case 'banner':
          return BannerElement.fromJson(elementData);
        case 'image_gallery':
          return ImageGallery.fromJson(elementData);
        case 'product_gallery_1':
        case 'product_gallery_2':
        case 'product_gallery_3':
        case 'product_gallery_4':
          return ProductGallery.fromJson(elementData);

        case 'product_grid':
          return ProductGrid.fromJson(elementData);

        case 'product_grid_vertical':
          return ProductGridVertical.fromJson(elementData);

        case 'product_grid_vertical2':
          return ProductGridVertical2.fromJson(elementData);

        default:
          print('Unknown element type: $elementType');
          return null;
      }
    } catch (e) {
      print('Error parsing element type $elementType: $e');
      return null;
    }
  }

  factory Rows.fromJson(Map<String, dynamic> e) {
    final List<PageElement> parsedElements =
        (e['elements'] as List<dynamic>? ?? [])
            .map((el) => _parseElement(el as Map<String, dynamic>))
            .whereType<PageElement>() // removes nulls safely
            .toList();

    return Rows(
      row_id: e['row_id'] ?? 0,
      layout_id: e['layout_id'] ?? 0,
      styling:
          e['styling'] != null
              ? Styling.fromJson(e['styling'])
              : Styling(
                backgroud_color: '',
                backgroud_image: '',
                height: '',
                border_color: '',
                padding: '',
                margin: '',
                border_radius: '',
                border_width: '',
                border_style: '',
              ),
      elements: parsedElements,
    );
  }
}

class Pagemodel {
  final int page_id;
  final String title;
  final String slug;
  final MetaData meta;
  final List<Rows> rows;
  Pagemodel({
    required this.page_id,
    required this.title,
    required this.slug,
    required this.meta,
    required this.rows,
  });
  factory Pagemodel.fromJson(Map<String, dynamic> e) {
    return Pagemodel(
      page_id: e['page_id'] ?? 0,
      title: e['title'] ?? '',
      slug: e['slug'] ?? '',
      meta:
          e['meta'] != null
              ? MetaData.fromJson(e['meta'])
              : MetaData(title: '', description: '', keywords: ''),
      rows:
          (e['rows'] as List<dynamic>? ?? [])
              .map((row) => Rows.fromJson(row as Map<String, dynamic>))
              .toList(),
    );
  }
}
