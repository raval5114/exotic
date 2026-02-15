part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {}

final class SplashScreenInitial extends SplashScreenState {}

final class SplashScreenLoadingState extends SplashScreenState {}

final class SplashScreenSuccessedState extends SplashScreenState {
  final bool islogged;
  final User user;
  final List<Category> data;
  SplashScreenSuccessedState({
    required this.islogged,
    required this.data,
    required this.user,
  });
}

final class SplashScreenFetchedState extends SplashScreenState {
  final List<Map<String, dynamic>> data;

  SplashScreenFetchedState({required this.data});
}

final class SplashScrennErrorState extends SplashScreenState {
  final String errMsg;

  SplashScrennErrorState({required this.errMsg});
}
