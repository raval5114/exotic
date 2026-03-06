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

final class HomepagePagesFetchedState extends HomepageState {
  final List<Map<String, dynamic>> data;

  HomepagePagesFetchedState({required this.data});
}

class HomepageTabLoadingState extends HomepageState {
  final String slug;
  HomepageTabLoadingState(this.slug);
}

class HomepageApiFetchedState extends HomepageState {
  final String slug;
  final Map<String, dynamic> data;

  HomepageApiFetchedState({required this.slug, required this.data});
}
