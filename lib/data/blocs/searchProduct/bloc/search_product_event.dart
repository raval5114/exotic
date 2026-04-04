part of 'search_product_bloc.dart';

sealed class SearchProductEvent extends Equatable {
  const SearchProductEvent();

  @override
  List<Object?> get props => [];
}

final class SearchProductMetaDataEvent extends SearchProductEvent {
  @override
  List<Object?> get props => [];
}

/// Search with query
final class SearchProductSearchingEvent extends SearchProductEvent {
  final String query;

  const SearchProductSearchingEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Reset state without fetching
final class SearchProductClearEvent extends SearchProductEvent {}

final class SearchedProductDataCallingEvent extends SearchProductEvent {
  final String url;

  SearchedProductDataCallingEvent({required this.url});
}
