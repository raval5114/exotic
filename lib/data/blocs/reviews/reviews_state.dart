part of 'reviews_bloc.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoadingState extends ReviewsState {}

class ReviewsLoadedState extends ReviewsState {
  final ReviewsData reviewsData;
  ReviewsLoadedState(this.reviewsData);
}

class ReviewsErrorState extends ReviewsState {
  final String errorMessage;
  ReviewsErrorState(this.errorMessage);
}

class ReviewActionLoadingState extends ReviewsState {}

class ReviewActionSuccessState extends ReviewsState {
  final String message;
  ReviewActionSuccessState(this.message);
}

class ReviewActionErrorState extends ReviewsState {
  final String errorMessage;
  ReviewActionErrorState(this.errorMessage);
}

