part of 'homepage_testing_bloc.dart';

sealed class HomepageTestingState extends Equatable {
  const HomepageTestingState();

  @override
  List<Object> get props => [];
}

final class HomepageTestingInitial extends HomepageTestingState {}

final class HomepageTestingLoadingState extends HomepageTestingState {}

final class HomepageTestingFetchingPageTitleSuccessState
    extends HomepageTestingState {
  List<Map<String, dynamic>> data;

  HomepageTestingFetchingPageTitleSuccessState({required this.data});
}

final class HomepageTestingSuccessState extends HomepageTestingState {
  final Map<String, dynamic> data;

  const HomepageTestingSuccessState({required this.data});
}

final class HomepageErrorState extends HomepageTestingState {
  final String errMsg;

  const HomepageErrorState({required this.errMsg});
}
