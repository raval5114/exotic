class Category {
  final String id;
  final String parentId;
  final String name;
  final String url;
  final String status;
  final String? photo;
  final String? catIds;
  final String returnable;
  final List<Category> children;

  Category({
    required this.id,
    required this.parentId,
    required this.name,
    required this.url,
    required this.status,
    this.photo,
    this.catIds,
    required this.returnable,
    this.children = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['pc_id'] ?? '',
      parentId: json['pc_p_id'] ?? '0',
      name: json['pc_name'] ?? '',
      url: json['pc_url'] ?? '',
      status: json['pc_status'] ?? '0',
      photo: json['pc_photo'],
      catIds: json['pc_cat_id'],
      returnable: json['pc_return'] ?? '0',
      children:
          (json['children'] as List<dynamic>?)
              ?.map((child) => Category.fromJson(child))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pc_id': id,
      'pc_p_id': parentId,
      'pc_name': name,
      'pc_url': url,
      'pc_status': status,
      'pc_photo': photo,
      'pc_cat_id': catIds,
      'pc_return': returnable,
      'children': children.map((c) => c.toJson()).toList(),
    };
  }

  bool get isTopLevel => parentId == "0";
}
