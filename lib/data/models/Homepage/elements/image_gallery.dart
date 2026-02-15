import 'dart:convert';

import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class ImageGalleryContent {
  final String galleryMode;
  final String galleryWidth;
  final String height;
  final int gap;
  final int gridColumns;
  final bool autoplay;
  final int interval;
  final bool loop;
  final bool pauseOnHover;
  final int desktopPerView;
  final int mobilePerView;
  final int transitionTime;
  final String transitionEasing;
  final String backgroundColor;
  final String imageBorder;
  final String imageRadius;
  final String captionBackground;
  final String galleryTitle;
  final List<ImageGalleryItem> items;

  ImageGalleryContent({
    required this.galleryMode,
    required this.galleryWidth,
    required this.height,
    required this.gap,
    required this.gridColumns,
    required this.autoplay,
    required this.interval,
    required this.loop,
    required this.pauseOnHover,
    required this.desktopPerView,
    required this.mobilePerView,
    required this.transitionTime,
    required this.transitionEasing,
    required this.backgroundColor,
    required this.imageBorder,
    required this.imageRadius,
    required this.captionBackground,
    required this.galleryTitle,
    required this.items,
  });

  factory ImageGalleryContent.fromJson(Map<String, dynamic> json) {
    final List decodedItems =
        json['gallery_items'] != null ? jsonDecode(json['gallery_items']) : [];

    return ImageGalleryContent(
      galleryMode: json['gallery_mode'] ?? 'grid',
      galleryWidth: json['gallery_width'] ?? '',
      height: json['height'] ?? '',
      gap: int.tryParse(json['gap']?.toString() ?? '') ?? 0,
      gridColumns: int.tryParse(json['grid_columns']?.toString() ?? '') ?? 0,
      autoplay: json['autoplay'] == 'true',
      interval: int.tryParse(json['interval']?.toString() ?? '') ?? 0,
      loop: json['loop'] == 'true',
      pauseOnHover: json['pause_on_hover'] == 'true',
      desktopPerView:
          int.tryParse(json['desktop_per_view']?.toString() ?? '') ?? 0,
      mobilePerView:
          int.tryParse(json['mobile_per_view']?.toString() ?? '') ?? 0,
      transitionTime:
          int.tryParse(json['transition_time']?.toString() ?? '') ?? 0,
      transitionEasing: json['transition_easing'] ?? '',
      backgroundColor: json['background_color'] ?? '',
      imageBorder: json['image_border'] ?? '',
      imageRadius: json['image_radius'] ?? '',
      captionBackground: json['caption_background'] ?? '',
      galleryTitle: json['gallery_title'] ?? '',
      items: decodedItems.map((e) => ImageGalleryItem.fromJson(e)).toList(),
    );
  }
}

class ImageGalleryItem {
  final String productTitle;
  final String imageUrl;
  final String linkUrl;
  final String caption;

  ImageGalleryItem({
    required this.productTitle,
    required this.imageUrl,
    required this.linkUrl,
    required this.caption,
  });

  factory ImageGalleryItem.fromJson(Map<String, dynamic> json) {
    return ImageGalleryItem(
      productTitle: json['product_title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      linkUrl: json['link_url'] ?? '',
      caption: json['caption'] ?? '',
    );
  }
}

class ImageGallery implements PageElement {
  @override
  final int elementId;

  @override
  final String elementType;

  @override
  final String title;

  final ImageGalleryContent content;

  ImageGallery({
    required this.elementId,
    required this.elementType,
    required this.title,
    required this.content,
  });

  factory ImageGallery.fromJson(Map<String, dynamic> json) {
    return ImageGallery(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      content: ImageGalleryContent.fromJson(json['content'] ?? {}),
    );
  }

  @override
  // TODO: implement config
  ElementConfig get config => throw UnimplementedError();

  @override
  // TODO: implement items
  List<Items> get items => throw UnimplementedError();
}
