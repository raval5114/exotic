import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';

class Griditem implements Items {
  final String title;
  final String subtitle;
  final String link_url;
  final String image_url;

  Griditem({
    required this.title,
    required this.subtitle,
    required this.link_url,
    required this.image_url,
  });
  factory Griditem.fromJson(Map<String, dynamic> e) {
    return Griditem(
      title: e['title'] ?? '',
      subtitle: e['subtitle'] ?? '',
      link_url: e['link_url'] ?? '',
      image_url: e['image_url'] ?? '',
    );
  }
}
