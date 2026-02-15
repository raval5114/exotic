class RecentSearchesModel {
  final String imagePath;
  final String name;

  RecentSearchesModel({required this.imagePath, required this.name});

  factory RecentSearchesModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchesModel(
      imagePath: json['imagePath'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'imagePath': imagePath, 'name': name};
  }
}

class PopularProductsModel {
  final String imagePath;
  final String name;
  final String category;

  PopularProductsModel({
    required this.imagePath,
    required this.name,
    required this.category,
  });

  factory PopularProductsModel.fromJson(Map<String, dynamic> json) {
    return PopularProductsModel(
      imagePath: json['imagePath'] as String,
      name: json['name'] as String,
      category: json['categorie'] as String, // API key is "categorie"
    );
  }

  Map<String, dynamic> toJson() {
    return {'imagePath': imagePath, 'name': name, 'categorie': category};
  }
}

class MetaDataModel {
  final List<RecentSearchesModel> recentSearches;
  final List<PopularProductsModel> popularProducts;
  final List<String> discoverStrings;

  MetaDataModel({
    required this.recentSearches,
    required this.popularProducts,
    required this.discoverStrings,
  });

  factory MetaDataModel.fromJson({
    required List<Map<String, dynamic>> recentSearchData,
    required List<Map<String, dynamic>> popularProductsData,
    required List<String> discoverStrings,
  }) {
    return MetaDataModel(
      recentSearches:
          recentSearchData.map((e) => RecentSearchesModel.fromJson(e)).toList(),

      popularProducts:
          popularProductsData
              .map((e) => PopularProductsModel.fromJson(e))
              .toList(),

      discoverStrings: List<String>.from(discoverStrings),
    );
  }
}
