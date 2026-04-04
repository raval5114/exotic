import '../../models/search_product_model.dart';

abstract class SearchResultState {}

class SearchResultInitial extends SearchResultState {}

class SearchResultLoading extends SearchResultState {}

class SearchResultLoaded extends SearchResultState {
  final SearchProductResponse data;
  SearchResultLoaded({required this.data});
}

class SearchResultError extends SearchResultState {
  final String message;
  SearchResultError({required this.message});
}
