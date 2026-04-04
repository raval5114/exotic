part of 'search_product_bloc.dart';

sealed class SearchProductState extends Equatable {
  const SearchProductState();

  @override
  List<Object?> get props => [];
}

/// Initial
final class SearchProductInitial extends SearchProductState {
  const SearchProductInitial();
}

/// Loading
final class SearchProductLoadingState extends SearchProductState {
  const SearchProductLoadingState();
}

/// Search query result
final class SearchProductQueryResultState extends SearchProductState {
  final Map<String, dynamic> queryResult;

  const SearchProductQueryResultState({required this.queryResult});

  @override
  List<Object?> get props => [queryResult];
}

/// Metadata (recent / popular / discover)
final class SearchProductMetaDataState extends SearchProductState {
  final List<Map<String, dynamic>> recentSearchData;
  final List<Map<String, dynamic>> popularProducts;
  final List<String> discoverStrings;

  const SearchProductMetaDataState({
    required this.recentSearchData,
    required this.popularProducts,
    required this.discoverStrings,
  });

  @override
  List<Object?> get props => [
    recentSearchData,
    popularProducts,
    discoverStrings,
  ];
}

/// Error
final class SearchErrorState extends SearchProductState {
  final String errMsg;

  const SearchErrorState({required this.errMsg});

  @override
  List<Object?> get props => [errMsg];
}
