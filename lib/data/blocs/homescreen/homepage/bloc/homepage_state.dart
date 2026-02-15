part of 'homepage_bloc.dart';

@immutable
sealed class HomepageState {}

final class HomepageInitial extends HomepageState {}

final class HomepageLoadingState extends HomepageState {}

final class HomePageActionState extends HomepageState {}

final class HomepageAddImageSuccessState extends HomepageState {
  final List<String> imagePath;
  HomepageAddImageSuccessState({required this.imagePath});
}

final class HomepageErrorState extends HomepageState {
  final String errMsg;
  HomepageErrorState({required this.errMsg});
}

final class HomePageCategoriesFetchedState extends HomepageState {
  final List<Category> categories;
  HomePageCategoriesFetchedState({required this.categories});
}

final class HomepageSectionFetchedState extends HomepageState {
  final List<Map<String, dynamic>> data;

  HomepageSectionFetchedState({required this.data});
}

final class HomepageApiFetchedState extends HomepageState {
  final Map<String, dynamic> data;

  HomepageApiFetchedState({required this.data});
}
