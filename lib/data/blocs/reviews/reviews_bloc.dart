import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/models/reviews.dart';
import 'package:exotic/data/domains/reviews/reviews.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final Reviews _reviews = Reviews();

  ReviewsBloc() : super(ReviewsInitial()) {
    on<FetchReviewsEvent>((event, emit) async {
      emit(ReviewsLoadingState());
      try {
        Map<String, dynamic> rawData = await _reviews.getReviews(
          event.productId,
        );
        ReviewsModel parsedData = ReviewsModel.fromJson(rawData);

        emit(ReviewsLoadedState(parsedData.data));
      } catch (e) {
        emit(ReviewsErrorState(e.toString()));
      }
    });

    on<AddReviewEvent>((event, emit) async {
      final currentState = state;
      emit(ReviewActionLoadingState());
      try {
        await _reviews.addReview(
            event.customerId,
            event.productId,
            event.overallRating,
            event.qualityRating,
            event.valueRating,
            event.deliveryRating,
            event.reviewTitle,
            event.reviewText,
            event.pros,
            event.cons,
            event.orderId,
            event.orderItemId,
        );
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
        await _reviews.updateReview(event.reviewId, event.reviewData);
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
