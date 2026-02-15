import 'dart:convert';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

bool parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}

int parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class BannerItem {
  final String linkUrl;
  final String imageUrl;
  final String imageFile;
  final String mobileImageUrl;
  final String mobileImageFile;
  final String mobileLinkUrl;

  BannerItem({
    required this.linkUrl,
    required this.imageUrl,
    required this.imageFile,
    required this.mobileImageUrl,
    required this.mobileImageFile,
    required this.mobileLinkUrl,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      linkUrl: json['link_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      imageFile: json['image_file'] ?? '',
      mobileImageUrl: json['mobile_image_url'] ?? '',
      mobileImageFile: json['mobile_image_file'] ?? '',
      mobileLinkUrl: json['mobile_link_url'] ?? '',
    );
  }
}

class BannerContent {
  final List<BannerItem> banners;
  final String galleryMode;
  final int transitionTime;
  final bool autoplay;
  final int interval;
  final bool loop;
  final bool pauseOnHover;
  final String galleryWidth;
  final String height;
  final int desktopPerView;
  final int mobilePerView;
  final int gap;
  final String backgroundColor;
  final String imageBorder;
  final String imageRadius;

  BannerContent({
    required this.banners,
    required this.galleryMode,
    required this.transitionTime,
    required this.autoplay,
    required this.interval,
    required this.loop,
    required this.pauseOnHover,
    required this.galleryWidth,
    required this.height,
    required this.desktopPerView,
    required this.mobilePerView,
    required this.gap,
    required this.backgroundColor,
    required this.imageBorder,
    required this.imageRadius,
  });
  factory BannerContent.fromJson(Map<String, dynamic> json) {
    List<BannerItem> parsedBanners = [];

    if (json['banners'] != null && json['banners'] is String) {
      final List decoded = jsonDecode(json['banners']);
      parsedBanners = decoded.map((e) => BannerItem.fromJson(e)).toList();
    }

    return BannerContent(
      banners: parsedBanners,
      galleryMode: json['gallery_mode'] ?? 'slide',
      transitionTime: parseInt(json['transition_time']),
      autoplay: parseBool(json['autoplay']),
      interval: parseInt(json['interval']),
      loop: parseBool(json['loop']),
      pauseOnHover: parseBool(json['pause_on_hover']),
      galleryWidth: json['gallery_width'] ?? '100%',
      height: json['height'] ?? 'auto',
      desktopPerView: parseInt(json['desktop_per_view']),
      mobilePerView: parseInt(json['mobile_per_view']),
      gap: parseInt(json['gap']),
      backgroundColor: json['background_color'] ?? '#ffffff',
      imageBorder: json['image_border'] ?? 'none',
      imageRadius: json['image_radius'] ?? '0px',
    );
  }
}

class BannerElement implements PageElement {
  final int elementId;
  final String elementType;
  final String title;
  final BannerContent content;

  BannerElement({
    required this.elementId,
    required this.elementType,
    required this.title,
    required this.content,
  });

  factory BannerElement.fromJson(Map<String, dynamic> json) {
    return BannerElement(
      elementId: json['element_id'] ?? 0,
      elementType: json['element_type'] ?? '',
      title: json['title'] ?? '',
      content: BannerContent.fromJson(json['content'] ?? {}),
    );
  }

  @override
  // TODO: implement config
  ElementConfig get config => throw UnimplementedError();

  @override
  // TODO: implement items
  List<Items> get items => throw UnimplementedError();
}
