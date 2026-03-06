class HomepagePageModel {
  final int pageId;

  final String title;

  final String slug;

  final String createdAt;

  HomepagePageModel({
    required this.pageId,
    required this.title,
    required this.slug,
    required this.createdAt,
  });

  factory HomepagePageModel.fromJson(Map<String, dynamic> e) {
    return HomepagePageModel(
      pageId: e['page_id'],
      title: e['title'],
      slug: e['slug'],
      createdAt: e['created_at'],
    );
  }
}
