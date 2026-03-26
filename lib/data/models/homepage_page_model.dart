class HomepagePageModel {
  final int pageId;

  final String title;

  final String slug;

  final String createdAt;

  final String modifiedAt;

  HomepagePageModel({
    required this.pageId,
    required this.title,
    required this.slug,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory HomepagePageModel.fromJson(Map<String, dynamic> e) {
    return HomepagePageModel(
      pageId: e['page_id'],
      title: e['title'],
      slug: e['slug'],
      createdAt: e['created_at'],
      modifiedAt: e['modified_at'] ?? '',
    );
  }
}
