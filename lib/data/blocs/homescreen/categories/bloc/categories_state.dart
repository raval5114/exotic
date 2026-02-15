part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesPageCategoriesLoadingState extends CategoriesState {}

final class CategoriesPageErrorState extends CategoriesState {
  final String errMsg;
  CategoriesPageErrorState({required this.errMsg});
}

final class CategoriesPageCategoriesFetchedState extends CategoriesState {
  final List<Category> data;

  CategoriesPageCategoriesFetchedState({required this.data});
}

final class CategoriesPageSubcategoriesFetchedState extends CategoriesState {
  final List<Map<String, dynamic>> data;

  CategoriesPageSubcategoriesFetchedState({required this.data});
}
