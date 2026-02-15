part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {}

final class CategoriesPageCategoriesFetchingEvent extends CategoriesEvent {
  final List<Category> categories;
  CategoriesPageCategoriesFetchingEvent({required this.categories});
}

final class CategoriesPageSubcategoriesFetchingEvent extends CategoriesEvent {
  final List<Map<String, dynamic>> data;
  CategoriesPageSubcategoriesFetchingEvent({required this.data});
}
