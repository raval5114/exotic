import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Fields {
  final bool image;
  final bool name;
  final bool price;
  final bool mrp;
  final bool discount;
  final bool rating;
  Fields({
    required this.image,
    required this.name,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.rating,
  });
  factory Fields.fromJson(Map<String, dynamic> e) {
    return Fields(
      image: e['image'] ?? true,
      name: e['name'] ?? true,
      price: e['price'] ?? true,
      mrp: e['mrp'] ?? true,
      discount: e['discount'] ?? true,
      rating: e['discount'] ?? true,
    );
  }
}

class GalleryBanner {
  final String position;
  final String url;
  final String type;

  GalleryBanner({
    required this.position,
    required this.url,
    required this.type,
  });

  factory GalleryBanner.fromJson(Map<String, dynamic> json) {
    return GalleryBanner(
      position: json['position'] ?? 'none',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class GalleryFields {
  final bool image;
  final bool name;
  final bool price;
  final bool mrp;
  final bool discount;
  final bool rating;

  GalleryFields({
    required this.image,
    required this.name,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.rating,
  });

  factory GalleryFields.fromJson(Map<String, dynamic> json) {
    return GalleryFields(
      image: json['image'] ?? false,
      name: json['name'] ?? false,
      price: json['price'] ?? false,
      mrp: json['mrp'] ?? false,
      discount: json['discount'] ?? false,
      rating: json['rating'] ?? false,
    );
  }
}

class GallerySlider {
  final bool showArrows;
  final bool autoplay;
  final int interval;
  final String direction;
  final int animSpeed;

  GallerySlider({
    required this.showArrows,
    required this.autoplay,
    required this.interval,
    required this.direction,
    required this.animSpeed,
  });

  factory GallerySlider.fromJson(Map<String, dynamic> json) {
    return GallerySlider(
      showArrows: json['show_arrows'] ?? false,
      autoplay: json['autoplay'] ?? false,
      interval: json['interval'] ?? 0,
      direction: json['direction'] ?? 'left',
      animSpeed: json['anim_speed'] ?? 0,
    );
  }
}

class ProductGalleryConfig implements ElementConfig {
  final String galleryTitle;
  final String viewMoreUrl;
  final int galleryWidth;
  final GallerySlider slider;
  final GalleryFields fields;
  final GalleryBanner banner;

  ProductGalleryConfig({
    required this.galleryTitle,
    required this.viewMoreUrl,
    required this.galleryWidth,
    required this.slider,
    required this.fields,
    required this.banner,
  });

  factory ProductGalleryConfig.fromJson(Map<String, dynamic> json) {
    return ProductGalleryConfig(
      galleryTitle: json['gallery_title'] ?? '',
      viewMoreUrl: json['view_more_url'] ?? '',
      galleryWidth: json['gallery_width'] ?? 0,
      slider: GallerySlider.fromJson(json['slider'] ?? {}),
      fields: GalleryFields.fromJson(json['fields'] ?? {}),
      banner: GalleryBanner.fromJson(json['banner'] ?? {}),
    );
  }
}
