import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Bannerconfig extends ElementConfig {
  final bool autoplay;
  final int interval;
  final bool loop;
  final String effect;
  final bool showPagination;
  final bool showNavigation;

  Bannerconfig({
    required this.autoplay,
    required this.interval,
    required this.loop,
    required this.effect,
    required this.showPagination,
    required this.showNavigation,
  });

  factory Bannerconfig.fromJson(Map<String, dynamic> json) {
    return Bannerconfig(
      autoplay: json['autoplay'],
      interval: json['interval'],
      loop: json['loop'],
      effect: json['effect'],
      showPagination: json['show_pagination'],
      showNavigation: json['show_navigation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoplay': autoplay,
      'interval': interval,
      'loop': loop,
      'effect': effect,
      'show_pagination': showPagination,
      'show_navigation': showNavigation,
    };
  }
}
