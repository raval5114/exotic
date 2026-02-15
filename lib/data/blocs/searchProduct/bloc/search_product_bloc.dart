import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exotic/data/domains/searchProduct/searchProduct.dart';
import 'package:exotic/utils/injection.dart';
import 'package:rxdart/rxdart.dart';

part 'search_product_event.dart';
part 'search_product_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}

class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  SearchProductBloc() : super(SearchProductInitial()) {
    on<SearchProductSearchingEvent>((event, emit) async {
      emit(SearchProductLoadingState());
      try {
        final data = await getit<SearchproductRepo>().searchProduct(
          event.query,
        );

        emit(SearchProductQueryResultState(queryResult: data));
      } catch (e) {
        emit(SearchErrorState(errMsg: e.toString()));
      }
    }, transformer: debounce(const Duration(milliseconds: 400)));

    on<SearchProductMetaDataEvent>((event, emit) async {
      emit(SearchProductLoadingState());
      try {
        final popularData = await getit<SearchproductRepo>().fetchPopularData();
        final recentData = await getit<SearchproductRepo>().fetchRecentData();
        final discoverData =
            await getit<SearchproductRepo>().fetchDiscoverData();

        emit(
          SearchProductMetaDataState(
            recentSearchData: recentData,
            popularProducts: popularData,
            discoverStrings: discoverData,
          ),
        );
      } catch (e) {
        emit(SearchErrorState(errMsg: e.toString()));
      }
    });
  }
}
