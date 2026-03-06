part of 'homepage_bloc.dart';

@immutable
sealed class HomepageEvent {}

final class HomePageAdImagesFetchingEvent extends HomepageEvent {}

final class HomePageCategoriesFetchingEvent extends HomepageEvent {
  final List<Category> categories;

  HomePageCategoriesFetchingEvent({required this.categories});
}

final class HomePageSectionFetchingEvent extends HomepageEvent {
  final List<Map<String, dynamic>> productsitmes;

  HomePageSectionFetchingEvent({required this.productsitmes});
}

final class HomepageApiFetcingEvent extends HomepageEvent {
  final String Slug;
  HomepageApiFetcingEvent({required this.Slug});
}

final class HomepagePagesFetchingEvent extends HomepageEvent {}
