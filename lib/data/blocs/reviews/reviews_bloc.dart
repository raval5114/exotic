import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/models/reviews.dart';
import 'package:exotic/data/domains/reviews/reviews.dart';
import 'package:exotic/data/providers/reviews_provider.dart';
import 'package:exotic/utils/injection.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  ReviewsBloc() : super(ReviewsInitial()) {
    on<FetchReviewsEvent>((event, emit) async {
      emit(ReviewsLoadingState());
      try {
        Map<String, dynamic> rawData = await getit<Reviews>().getReviews(event.productId);
        ReviewsData parsedData = ReviewsData.fromJson(rawData);
        
        // Assigning the reviews in provider
        getit<ReviewsProvider>().setReviewsData(parsedData);
        
        emit(ReviewsLoadedState(parsedData));
      } catch (e) {
        emit(ReviewsErrorState(e.toString()));
      }
    });

    on<AddReviewEvent>((event, emit) async {
      final currentState = state;
      emit(ReviewActionLoadingState());
      try {
        await getit<Reviews>().addReview(event.productId, event.reviewData);
        emit(ReviewActionSuccessState("Review submitted successfully!"));
        // Refetch to see the new data visually (even if simulated)
        add(FetchReviewsEvent(event.productId));
      } catch (e) {
        emit(ReviewActionErrorState(e.toString()));
        if (currentState is ReviewsLoadedState) {
          emit(currentState);
        }
      }
    });

    on<UpdateReviewEvent>((event, emit) async {
      final currentState = state;
      emit(ReviewActionLoadingState());
      try {
        await getit<Reviews>().updateReview(event.reviewId, event.reviewData);
        emit(ReviewActionSuccessState("Review updated successfully!"));
        
        if (currentState is ReviewsLoadedState) {
          add(FetchReviewsEvent(currentState.reviewsData.summary.productId));
        }
      } catch (e) {
        emit(ReviewActionErrorState(e.toString()));
        if (currentState is ReviewsLoadedState) {
          emit(currentState);
        }
      }
    });

    on<DeleteReviewEvent>((event, emit) async {
      // Future implementation
    });
  }
}
