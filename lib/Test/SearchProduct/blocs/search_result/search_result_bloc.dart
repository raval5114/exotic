import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repos/search_product.dart';
import '../../models/search_product_model.dart';
import 'search_result_event.dart';
import 'search_result_state.dart';

class SearchResultBlocTesting
    extends Bloc<SearchResultEvent, SearchResultState> {
  final SearchProductTesingService _service = SearchProductTesingService();

  SearchResultBlocTesting() : super(SearchResultInitial()) {
    on<SearchResultFetchEvent>((event, emit) async {
      emit(SearchResultLoading());
      try {
        final responseData = await _service.searchProduct(event.query);
        final parsedData = SearchProductResponse.fromJson(responseData);
        emit(SearchResultLoaded(data: parsedData));
      } catch (e) {
        print("${e}");
        emit(SearchResultError(message: e.toString()));
      }
    });

    on<SearchResultClearEvent>((event, emit) {
      emit(SearchResultInitial());
    });
  }
}
