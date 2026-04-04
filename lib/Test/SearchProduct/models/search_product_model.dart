class SearchProductResponse {
  final bool? success;
  final String? query;
  final List<SearchSuggestion>? suggestions;

  SearchProductResponse({
    this.success,
    this.query,
    this.suggestions,
  });

  factory SearchProductResponse.fromJson(Map<String, dynamic> json) {
    return SearchProductResponse(
      success: json['success'] as bool?,
      query: json['query'] as String?,
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => SearchSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'query': query,
      'suggestions': suggestions?.map((e) => e.toJson()).toList(),
    };
  }
}

class SearchSuggestion {
  final String? id;
  final String? type;
  final String? title;
  final String? subtitle;
  final String? image;
  final String? action;
  final Map<String, dynamic>? params;
  final String? dataUrl;

  SearchSuggestion({
    this.id,
    this.type,
    this.title,
    this.subtitle,
    this.image,
    this.action,
    this.params,
    this.dataUrl,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      id: json['id']?.toString(), // Handle both null and integer/string inputs
      type: json['type'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      image: json['image'] as String?,
      action: json['action'] as String?,
      params: json['params'] as Map<String, dynamic>?,
      dataUrl: json['data_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'action': action,
      'params': params,
      'data_url': dataUrl,
    };
  }
}
