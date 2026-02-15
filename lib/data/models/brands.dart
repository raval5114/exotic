class Brands {
  final String id;
  final String name;
  final String url;
  Brands({required this.id, required this.name, required this.url});
  factory Brands.fromJson(Map<String, dynamic> json) {
    return Brands(
      id: json['b_id'] as String,
      name: json['b_name'] as String,
      url: json['b_url'] as String,
    );
  }
}
